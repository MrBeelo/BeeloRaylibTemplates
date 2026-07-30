package main

import rl "vendor:raylib"

should_close := false
window_size :: [2]i32{800, 450}

init :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(window_size.x, window_size.y, "OdinTemp")
}

update :: proc() {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	
	rl.ClearBackground(rl.WHITE)
        
	DrawTextStyled(rl.GetFontDefault(), "This changes the [cFF0000FF]foreground color[r] of provided text!!!",
		{100, 80}, 20, 2, rl.BLACK)

    DrawTextStyled(rl.GetFontDefault(), "This changes the [bFF00FFFF]background color[r] of provided text!!!",
        {100, 120}, 20, 2, rl.BLACK)

    DrawTextStyled(rl.GetFontDefault(), "This changes the [c00ff00ff][bff0000ff]foreground and background colors[r]!!!",
        {100, 160}, 20, 2, rl.BLACK)

    DrawTextStyled(rl.GetFontDefault(), "This changes the [c00ff00ff]alpha[r] relative [cffffffff][b000000ff]from source[r] [cff000088]color[r]!!!",
        {100, 200}, 20, 2, {0, 0, 0, 100})

    free_all(context.temp_allocator)
}

close :: proc() { 
	rl.CloseWindow() 
}