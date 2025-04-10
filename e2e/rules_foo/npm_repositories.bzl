"@generated by @aspect_rules_js//npm/private:npm_translate_lock.bzl from //foo:pnpm-lock.yaml"

load("@aspect_rules_js//npm:npm_import.bzl", "npm_import")

def npm_repositories():
    "Generated npm_import repository rules corresponding to npm packages in //foo:pnpm-lock.yaml"
    npm_import(
        name = "rules_foo_npm__at_aspect-test_a__5.0.0",
        root_package = "foo",
        link_workspace = "rules_foo",
        link_packages = {
            "foo": ["@aspect-test/a"],
        },
        package = "@aspect-test/a",
        version = "5.0.0",
        lifecycle_hooks_no_sandbox = True,
        integrity = "sha512-t/lwpVXG/jmxTotGEsmjwuihC2Lvz/Iqt63o78SI3O5XallxtFp5j2WM2M6HwkFiii9I42KdlAF8B3plZMz0Fw==",
        deps = {
            "@aspect-test/b": "5.0.0",
            "@aspect-test/c": "1.0.0",
            "@aspect-test/d": "2.0.0_@aspect-test+c@1.0.0",
        },
        transitive_closure = {
            "@aspect-test/a": ["5.0.0"],
            "@aspect-test/b": ["5.0.0"],
            "@aspect-test/c": ["2.0.0", "1.0.0"],
            "@aspect-test/d": ["2.0.0_@aspect-test+c@2.0.0", "2.0.0_@aspect-test+c@1.0.0"],
        },
    )

    npm_import(
        name = "rules_foo_npm__at_aspect-test_b__5.0.0",
        root_package = "foo",
        link_workspace = "rules_foo",
        link_packages = {},
        package = "@aspect-test/b",
        version = "5.0.0",
        lifecycle_hooks_no_sandbox = True,
        integrity = "sha512-MyIW6gHL3ds0BmDTOktorHLJUya5eZLGZlOxsKN2M9c3DWp+p1pBrA6KLQX1iq9BciryhpKwl82IAxP4jG52kw==",
        deps = {
            "@aspect-test/a": "5.0.0",
            "@aspect-test/c": "2.0.0",
            "@aspect-test/d": "2.0.0_@aspect-test+c@2.0.0",
        },
        transitive_closure = {
            "@aspect-test/b": ["5.0.0"],
            "@aspect-test/a": ["5.0.0"],
            "@aspect-test/c": ["1.0.0", "2.0.0"],
            "@aspect-test/d": ["2.0.0_@aspect-test+c@1.0.0", "2.0.0_@aspect-test+c@2.0.0"],
        },
    )

    npm_import(
        name = "rules_foo_npm__at_aspect-test_c__1.0.0",
        root_package = "foo",
        link_workspace = "rules_foo",
        link_packages = {},
        package = "@aspect-test/c",
        version = "1.0.0",
        lifecycle_hooks_no_sandbox = True,
        integrity = "sha512-UorLD4TFr9CWFeYbUd5etaxSo201fYEFR+rSxXytfzefX41EWCBabsXhdhvXjK6v/HRuo1y1I1NiW2P3/bKJeA==",
        transitive_closure = {
            "@aspect-test/c": ["1.0.0"],
        },
        run_lifecycle_hooks = True,
    )

    npm_import(
        name = "rules_foo_npm__at_aspect-test_c__2.0.0",
        root_package = "foo",
        link_workspace = "rules_foo",
        link_packages = {},
        package = "@aspect-test/c",
        version = "2.0.0",
        lifecycle_hooks_no_sandbox = True,
        integrity = "sha512-vRuHi/8zxZ+IRGdgdX4VoMNFZrR9UqO87yQx61IGIkjgV7QcKUeu5jfvIE3Mr0WNQeMdO1JpyTx1UUpsE73iug==",
        transitive_closure = {
            "@aspect-test/c": ["2.0.0"],
        },
        run_lifecycle_hooks = True,
    )

    npm_import(
        name = "rules_foo_npm__at_aspect-test_d__2.0.0__at_aspect-test_c_1.0.0",
        root_package = "foo",
        link_workspace = "rules_foo",
        link_packages = {},
        package = "@aspect-test/d",
        version = "2.0.0_@aspect-test+c@1.0.0",
        lifecycle_hooks_no_sandbox = True,
        integrity = "sha512-jndwr8pLUfn795uApTcXG/yZ5hV2At1aS/wo5BVLxqlVVgLoOETF/Dp4QOjMHE/SXkXFowz6Hao+WpmzVvAO0A==",
        deps = {
            "@aspect-test/c": "1.0.0",
        },
        transitive_closure = {
            "@aspect-test/d": ["2.0.0_@aspect-test+c@1.0.0"],
            "@aspect-test/c": ["1.0.0"],
        },
    )

    npm_import(
        name = "rules_foo_npm__at_aspect-test_d__2.0.0__at_aspect-test_c_2.0.0",
        root_package = "foo",
        link_workspace = "rules_foo",
        link_packages = {},
        package = "@aspect-test/d",
        version = "2.0.0_@aspect-test+c@2.0.0",
        lifecycle_hooks_no_sandbox = True,
        integrity = "sha512-jndwr8pLUfn795uApTcXG/yZ5hV2At1aS/wo5BVLxqlVVgLoOETF/Dp4QOjMHE/SXkXFowz6Hao+WpmzVvAO0A==",
        deps = {
            "@aspect-test/c": "2.0.0",
        },
        transitive_closure = {
            "@aspect-test/d": ["2.0.0_@aspect-test+c@2.0.0"],
            "@aspect-test/c": ["2.0.0"],
        },
    )
