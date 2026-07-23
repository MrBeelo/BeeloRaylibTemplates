package main

import rl "vendor:raylib"

mode: enum{RGS, BUILTIN} = .BUILTIN

main :: proc() {
	rl.InitWindow(400, 200, "raygui - controls test suite")
	rl.SetTargetFPS(60)

	switch mode {
	case .RGS: rl.GuiLoadStyle("res/jungle.rgs")
	case .BUILTIN: GuiLoadStyleCyber()
	}

	showMessageBox := false

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.GetColor(u32(rl.GuiGetStyle(.DEFAULT, i32(rl.GuiDefaultProperty.BACKGROUND_COLOR)))))

		if rl.GuiButton({24, 24, 120, 30}, "#191#Show Message") do showMessageBox = true

		if showMessageBox {
			btnActive := rl.GuiMessageBox({85, 70, 250, 100}, "#191#Message Box", "Hi! This is a message!", "Nice;Cool")
			if btnActive >= 0 do showMessageBox = false
		}

		rl.EndDrawing()
	}

	rl.CloseWindow()
}