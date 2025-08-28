const std = @import("std");
const rl = @import("raylib");

pub const allocator = std.heap.page_allocator;

pub fn main() anyerror!void {
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "ZigBindingsTemp");
    defer rl.closeWindow();
    
    const blob = try rl.loadTexture("res/blob.png");
    defer rl.unloadTexture(blob);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        
        rl.clearBackground(.white);
        
        rl.drawText("Congrats! You created your first window!", 190, 200, 20, .light_gray);
        rl.drawTexture(blob, 400 - @divFloor(blob.width, 2), 150, .white);
        rl.drawText(try std.fmt.allocPrintSentinel(allocator, "FPS: {d:.1}", .{rl.getFPS()}, 0), 10, 10, 32, .light_gray);
    }
}
