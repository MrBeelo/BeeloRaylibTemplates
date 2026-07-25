package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc() {
    screenWidth :: 800;
    screenHeight :: 450;
    
    rl.InitWindow(screenWidth, screenHeight, "OdinTemp");
    defer rl.CloseWindow();
    
    blob := rl.LoadTexture("res/blob.png");
    defer rl.UnloadTexture(blob);
    
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        defer rl.EndDrawing();
        
        rl.ClearBackground(rl.WHITE);
        
        rl.DrawText("Congrats! You created your first window!", 190, 200, 20, rl.LIGHTGRAY);
        rl.DrawTexture(blob, 400 - blob.width / 2, 150, rl.WHITE);
        rl.DrawText(fmt.ctprintf("FPS: %d", rl.GetFPS()), 10, 10, 32, rl.LIGHTGRAY);
    }
}