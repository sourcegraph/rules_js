"Helper utility for working with pnpm lockfile"

load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@bazel_skylib//lib:types.bzl", "types")
load(":utils.bzl", "utils")

def gather_transitive_closure(packages, no_optional, direct_deps, transitive_closure):
    """Walk the dependency tree, collecting the transitive closure of dependencies and their versions.

    This is needed to resolve npm dependency cycles.
    Note: Starlark expressly forbids recursion and infinite loops, so we need to iterate over a large range of numbers,
    where each iteration takes one item from the stack, and possibly adds many new items to the stack.

    Args:
        packages: dictionary from pnpm lock
        no_optional: whether to exclude optionalDependencies
        direct_deps: the immediate dependencies of a given package
        transitive_closure: a dictionary which is mutated as the return value
    """
    stack = [direct_deps]
    iteration_max = 999999
    for i in range(0, iteration_max + 1):
        if not len(stack):
            break
        if i == iteration_max:
            fail("gather_transitive_closure exhausted the iteration limit of %s - please report this issue" % iteration_max)
        deps = stack.pop()
        for name in deps.keys():
            version = deps[name]
            if version[0].isdigit():
                package_key = utils.pnpm_name(name, version)
            elif version.startswith("/"):
                # an aliased dependency
                version = version[1:]
                package_key = version
                name, version = utils.parse_pnpm_name(version)
            else:
                package_key = version
            transitive_closure[name] = transitive_closure.get(name, [])
            if version in transitive_closure[name]:
                continue
            transitive_closure[name].insert(0, version)
            package_info = packages[package_key]
            stack.append(package_info["dependencies"] if no_optional else dicts.add(package_info["dependencies"], package_info["optionalDependencies"]))

def _gather_package_info(package_path, package_snapshot):
    if package_path.startswith("/"):
        # an aliased dependency
        package = package_path[1:]
        name, version = utils.parse_pnpm_name(package)
        friendly_version = utils.strip_peer_dep_version(version)
        package_key = package
    elif package_path.startswith("file:"):
        package = package_path
        if "name" not in package_snapshot:
            fail("expected package %s to have a name field" % package_path)
        name = package_snapshot["name"]
        version = package_path
        friendly_version = package_snapshot["version"] if "version" in package_snapshot else version
        package_key = package
    else:
        package = package_path
        if "name" not in package_snapshot:
            fail("expected package %s to have a name field" % package_path)
        if "version" not in package_snapshot:
            fail("expected package %s to have a version field" % package_path)
        name = package_snapshot["name"]
        version = package_path
        friendly_version = package_snapshot["version"]
        package_key = package

    if "resolution" not in package_snapshot:
        fail("package %s has no resolution field" % package_path)
    resolution = package_snapshot["resolution"]
    integrity = resolution["integrity"] if "integrity" in resolution else None
    tarball = resolution["tarball"] if "tarball" in resolution else None
    directory = resolution["directory"] if "directory" in resolution else None
    if not integrity and not tarball and not directory:
        fail("expected package %s to have an integrity, tarball or directory fields but found none" % package_path)
    registry = resolution["registry"] if "registry" in resolution else None

    return package_key, {
        "name": name,
        "version": version,
        "friendly_version": friendly_version,
        "integrity": integrity,
        "tarball": tarball,
        "directory": directory,
        "registry": registry,
        "dependencies": package_snapshot.get("dependencies", {}),
        "optionalDependencies": package_snapshot.get("optionalDependencies", {}),
        "dev": "dev" in package_snapshot.keys(),
        "optional": "optional" in package_snapshot.keys(),
        "hasBin": "hasBin" in package_snapshot.keys(),
        "requiresBuild": "requiresBuild" in package_snapshot.keys(),
    }

def translate_to_transitive_closure(lockfile, prod = False, dev = False, no_optional = False):
    """Implementation detail of translate_package_lock, converts pnpm-lock to a different dictionary with more data.

    Args:
        lockfile: a starlark dictionary representing the pnpm lockfile
        prod: If true, only install dependencies
        dev: If true, only install devDependencies
        no_optional: If true, optionalDependencies are not installed

    Returns:
        Nested dictionary suitable for further processing in our repository rule
    """
    if not types.is_dict(lockfile):
        fail("lockfile should be a starlark dict")
    if "lockfileVersion" not in lockfile.keys():
        fail("expected lockfileVersion key in lockfile")
    if "packages" not in lockfile.keys():
        fail("expected packages key in lockfile")
    utils.assert_lockfile_version(lockfile["lockfileVersion"])

    lock_importers = lockfile.get("importers", {
        ".": {
            "specifiers": lockfile.get("specifiers", {}),
            "dependencies": lockfile.get("dependencies", {}),
            "optionalDependencies": lockfile.get("optionalDependencies", {}),
            "devDependencies": lockfile.get("devDependencies", {}),
        },
    })
    lock_packages = lockfile.get("packages")

    importers = {}
    for importPath in lock_importers.keys():
        lock_importer = lock_importers[importPath]
        prod_deps = {} if dev else lock_importer.get("dependencies", {})
        dev_deps = {} if prod else lock_importer.get("devDependencies", {})
        opt_deps = {} if no_optional else lock_importer.get("optionalDependencies", {})
        importers[importPath] = {
            "dependencies": dicts.add(prod_deps, dev_deps, opt_deps),
        }

    packages = {}
    for package_path, package_snapshot in lock_packages.items():
        package, package_info = _gather_package_info(package_path, package_snapshot)
        packages[package] = package_info

    for package in packages.keys():
        package_info = packages[package]
        transitive_closure = {}
        transitive_closure[package_info["name"]] = [package_info["version"]]
        dependencies = package_info["dependencies"] if no_optional else dicts.add(package_info["dependencies"], package_info["optionalDependencies"])

        gather_transitive_closure(
            packages,
            no_optional,
            dependencies,
            transitive_closure,
        )

        package_info["transitiveClosure"] = transitive_closure

    return {
        "importers": importers,
        "packages": packages,
    }
