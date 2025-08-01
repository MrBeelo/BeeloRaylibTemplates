const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "CTemp",
        .target = target,
        .optimize = optimize,
    });
    
    const raylib_dep = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
    });
    
    const raylib_artifact = raylib_dep.artifact("raylib"); // raylib C library
    exe.linkLibrary(raylib_artifact);
    
    exe.linkLibC();
    
    const include_cpp_opt = b.option(bool, "include-cpp", "Includes the C++ standard library");
    if(include_cpp_opt orelse false) exe.linkLibCpp();
    
    var sources = std.ArrayList([]const u8).init(b.allocator);
    const path = "src";
    {
        var dir = try std.fs.cwd().openDir(path, .{ .iterate = true });
        
        var walker = try dir.walk(b.allocator);
        defer walker.deinit();
    
        const allowed_exts = [_][]const u8{ ".c", ".cpp" };
    
        while (try walker.next()) |entry| {
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
        exe.addCSourceFile(.{ .file = b.path(src)});
    }
    
    const sdk_path_opt = b.option([]const u8, "macos-sdk-path", "Path to macOS SDK");
    
    if (sdk_path_opt) |sdk_path| {
        const full_path = try std.fs.path.join(b.allocator, &[_][]const u8{sdk_path, "System/Library/Frameworks"});
        exe.addSystemFrameworkPath(b.path(full_path));
    }
    
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
