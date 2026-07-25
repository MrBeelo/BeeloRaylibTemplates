const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    
    const include_cpp_opt = b.option(bool, "include-cpp", "Includes the C++ standard library");
    
    const exe_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = include_cpp_opt
    });
    
    const raylib_dep = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
        .linux_display_backend = .X11
    });
    
    const raylib_artifact = raylib_dep.artifact("raylib");
    exe_mod.linkLibrary(raylib_artifact);
    
    var sources = std.array_list.Managed([]const u8).init(b.allocator);
    const path = "src";
    {
        var dir = try std.Io.Dir.cwd().openDir(b.graph.io, path, .{ .iterate = true });
        
        var walker = try dir.walk(b.allocator);
        defer walker.deinit();
    
        const allowed_exts = [_][]const u8{ ".c", ".cpp" };
    
        while (try walker.next(b.graph.io)) |entry| {
            const ext = std.fs.path.extension(entry.basename);
            const include_file = for (allowed_exts) |e| {
            if (std.mem.eql(u8, ext, e))
                break true;
            } else false;
    
            if (include_file) {
                const full_path = try std.fs.path.join(b.allocator, &.{path, entry.path});
                try sources.append(full_path);

                //try sources.append(b.dupe(entry.path));
            }
        }
    }
    
    for (sources.items) |src| {
        exe_mod.addCSourceFile(.{ .file = b.path(src)});
    }
    
    const sdk_path_opt = b.option([]const u8, "macos-sdk-path", "Path to macOS SDK");
    
    if (sdk_path_opt) |sdk_path| {
        const full_path = try std.fs.path.join(b.allocator, &[_][]const u8{sdk_path, "System/Library/Frameworks"});
        exe_mod.addSystemFrameworkPath(b.path(full_path));
    }
    
    const exe = b.addExecutable(.{
        .name = "CTemp",
        .root_module = exe_mod
    });
    
    b.installArtifact(exe);
    
    b.installDirectory(.{
        .source_dir = b.path("res"),
        .install_dir = .bin,
        .install_subdir = "res",
    });
    
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
