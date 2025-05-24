load("@bazel_skylib//rules/directory:providers.bzl", "DirectoryInfo")

def _cxx_toolchain(rctx):
    """Implementation for the llvm_toolchain repository rule."""
    rctx.download_and_extract(
        url = "https://github.com/reutermj/toolchains_cc/releases/download/binaries/llvm.tar.xz",
    )
    rctx.download_and_extract(
        url = "https://github.com/reutermj/toolchains_cc/releases/download/binaries/msvc.tar.xz",
    )
    rctx.download_and_extract(
        url = "https://github.com/reutermj/toolchains_cc/releases/download/binaries/ucrt.tar.xz",
    )
    rctx.download_and_extract(
        url = "https://github.com/reutermj/toolchains_cc/releases/download/binaries/winsdk.tar.xz",
    )

    # Create a BUILD file to make this a valid Bazel package
    rctx.file("BUILD", """
load("@rules_cc//cc/toolchains:args.bzl", "cc_args") 
load("@rules_cc//cc/toolchains:tool.bzl", "cc_tool")
load("@rules_cc//cc/toolchains:tool_map.bzl", "cc_tool_map")
load("@rules_cc//cc/toolchains:toolchain.bzl", "cc_toolchain")
load("@bazel_skylib//rules/directory:directory.bzl", "directory")
load("@bazel_skylib//rules/directory:subdirectory.bzl", "subdirectory")
load("@toolchains_cc//:toolchain.bzl", "hello_world")

package(default_visibility = ["//visibility:public"])

hello_world(
    name = "hello_world",
    directory = ":clang-include",
)

filegroup(
    name = "all_files",
    srcs = glob(["**"]),
)

directory(
    name = "root",
    srcs = [":all_files"],
)

subdirectory(
    name = "clang-include",
    parent = ":root",
    path = "toolchain/lib/clang/19/include",
)

subdirectory(
    name = "sysroot",
    parent = ":root",
    path = "sysroot",
)

subdirectory(
    name = "sysroot-include",
    parent = ":sysroot",
    path = "include",
)

subdirectory(
    name = "sysroot-lib",
    parent = ":sysroot",
    path = "lib",
)


toolchain(
    name = "host_toolchain",
    toolchain = ":host_cc_toolchain",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "host_cc_toolchain",
    args = [
        ":include-arg",
        ":link-arg",
    ],
    enabled_features = ["@rules_cc//cc/toolchains/args:experimental_replace_legacy_action_config_features"],
    known_features = ["@rules_cc//cc/toolchains/args:experimental_replace_legacy_action_config_features"],
    tool_map = ":all_tools",
)

cc_args(
    name = "include-arg",
    actions = [
        "@rules_cc//cc/toolchains/actions:c_compile",
        "@rules_cc//cc/toolchains/actions:cpp_compile_actions",
    ],
    args = [
        "-no-canonical-prefixes",
    ],
    env = {
        "INCLUDE": "{include}",
    },
    format = {
        "include": ":sysroot-include",
    },
    data = [
        ":sysroot-include",
    ],
)

cc_args(
    name = "link-arg",
    actions = [
        "@rules_cc//cc/toolchains/actions:link_actions",
    ],
    args = [
        "-no-canonical-prefixes",
    ],
    env = {
        "LIB": "{lib}",
    },
    format = {
        "lib": ":sysroot-lib",
    },
    data = [
        ":sysroot-lib",
    ],
)

cc_tool_map(
    name = "all_tools",
    tools = {
        "@rules_cc//cc/toolchains/actions:ar_actions": ":ar_actions",
        "@rules_cc//cc/toolchains/actions:assembly_actions": ":assembly_actions",
        "@rules_cc//cc/toolchains/actions:c_compile": ":c_compile",
        "@rules_cc//cc/toolchains/actions:cpp_compile_actions": ":cpp_compile_actions",
        "@rules_cc//cc/toolchains/actions:link_actions": ":link_actions",
        "@rules_cc//cc/toolchains/actions:objcopy_embed_data": ":objcopy_embed_data",
        "@rules_cc//cc/toolchains/actions:strip": ":strip",
    },
)

cc_tool(
    name = "ar_actions",
    src = "//:toolchain/bin/llvm-ar.exe",
    data = [
        ":all_files",
        ":clang-include",
    ],
)

cc_tool(
    name = "assembly_actions",
    src = "//:toolchain/bin/clang++.exe",
    data = [
        ":all_files",
        ":clang-include",
    ],
)

cc_tool(
    name = "c_compile",
    src = "//:toolchain/bin/clang.exe",
    data = [":clang-include"],
)

cc_tool(
    name = "cpp_compile_actions",
    src = "//:toolchain/bin/clang++.exe",
    data = [
        ":all_files",
        ":clang-include",
    ],
)

filegroup(
    name = "linker-files",
    srcs = [
        "//:toolchain/bin/ld.lld.exe",
        "//:toolchain/bin/ld64.lld.exe",
        "//:toolchain/bin/lld.exe",
        "//:toolchain/bin/lld-link.exe",
    ],
)

cc_tool(
    name = "link_actions",
    src = "//:toolchain/bin/clang++.exe",
    data = [
        ":linker-files", 
        ":all_files",
        ":clang-include",
    ],
)

cc_tool(
    name = "objcopy_embed_data",
    src = "//:toolchain/bin/llvm-objcopy.exe",
    data = [
        ":all_files",
        ":clang-include",
    ],
)

cc_tool(
    name = "strip",
    src = "//:toolchain/bin/llvm-strip.exe",
    data = [
        ":all_files",
        ":clang-include",
    ],
)
""")

cxx_toolchain = repository_rule(
    implementation = _cxx_toolchain,
)

def _hello_world_impl(ctx):
    print("Hello, world!")

hello_world = rule(
    implementation = _hello_world_impl,
     attrs = {
        "directory": attr.label(),
     },
)