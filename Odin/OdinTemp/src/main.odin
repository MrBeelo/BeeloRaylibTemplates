package main

import "core:fmt"
import rl "vendor:raylib"

should_close := false
window_size :: [2]i32{800, 450}
blob: rl.Texture2D

init :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(window_size.x, window_size.y, "OdinTemp")
	
	blob = rl.LoadTexture("res/blob.png")
}

update :: proc() {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	
	rl.ClearBackground(rl.WHITE)
        
    rl.DrawText("Congrats! You created your first window!", 190, 200, 20, rl.LIGHTGRAY)
    rl.DrawTexture(blob, 400 - blob.width / 2, 150, rl.WHITE)
    rl.DrawText(fmt.ctprintf("FPS: %d", rl.GetFPS()), 10, 10, 32, rl.LIGHTGRAY)

    free_all(context.temp_allocator)
}

close :: proc() { 
	rl.UnloadTexture(blob)
	rl.CloseWindow() 
}