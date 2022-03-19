includes("info.lua")
local info = build_info(info_lua)

add_rules("mode.debug", "mode.release")

option("include_logging")
    set_showmenu(true)
    set_description("Include verbose logging on run")
    add_defines("VERBOSE")


target("doorstop")
    set_kind("shared")
    set_optimize("smallest")
    add_options("include_logging")

    if is_os("windows") then
        includes("src/windows/build_tools/proxygen.lua")
        add_proxydef("src/windows/proxy/proxylist.txt")

        includes("src/windows/build_tools/rcgen.lua")
        add_rc(info)

        add_files("src/windows/*.c")
        add_defines("UNICODE")
        add_links("shell32", "kernel32", "user32")
    end

    if is_os("linux") or is_os("macosx") then
        add_files("src/nix/*.c")
        add_files("src/nix/plthook/*.c")
    end

    if is_plat("windows") then
        add_cxflags("-GS-", "-Ob2", "-MT", "-GL-", "-FS")
        add_shflags("-nodefaultlib",
                    "-entry:DllEntry",
                    "-dynamicbase:no",
                    {force=true})
    end

    if is_plat("mingw") then
        add_shflags("-nostdlib", "-nolibc", {force=true})

        if is_arch("i386") then
            add_shflags("-e _DllEntry", "-Wl,--enable-stdcall-fixup", {force=true})
        elseif is_arch("x86_64") then
            add_shflags("-e DllEntry", {force=true})
        end
    end

    add_files("src/*.c")
    add_files("src/config/*.c")
    add_files("src/util/*.c")
    add_files("src/runtimes/*.c")