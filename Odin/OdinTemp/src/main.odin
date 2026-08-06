package main

import "core:fmt"
import rl "vendor:raylib"
import "utils"

should_close := false
window_size :: [2]i32{800, 450}
blob: rl.Texture2D

init :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(window_size.x, window_size.y, "OdinTemp")
	utils.GuiLoadStyleCyber()
	
	blob = utils.LoadTextureFromMemory("../../res/blob.png")
}

update :: proc() {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	
	rl.ClearBackground(rl.GetColor(u32(rl.GuiGetStyle(.DEFAULT, 19))))
        
    utils.DrawTextStyled(rl.GetFontDefault(), "Congrats! You created your [cFF0000FF]first[r] window!", {190, 200}, 20, 2, rl.LIGHTGRAY)
    rl.DrawTexture(blob, 400 - blob.width / 2, 150, rl.WHITE)
    utils.DrawTextEx(rl.GetFontDefault(), string(fmt.ctprintf("FPS: %d", rl.GetFPS())), {10, 10}, 32, 2, rl.LIGHTGRAY)

    free_all(context.temp_allocator)
}

close :: proc() { 
	rl.UnloadTexture(blob)
	rl.CloseWindow() 
}