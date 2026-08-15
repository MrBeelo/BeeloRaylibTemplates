package main

main :: proc() {
	SetConfigFlags({.VSYNC_HINT})
	
	InitWindow(800, 450, "OdinTemp")
	defer CloseWindow()
	
	blob := LoadTexture("res/blob.png")
	defer UnloadTexture(blob)

	for !WindowShouldClose() {
		BeginDrawing()
		defer EndDrawing()

		ClearBackground(RAYWHITE)
		DrawText("Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY)
		DrawTexture(blob, 400 - blob.width / 2, 150, WHITE)
		GuiButton({10, 10, 100, 100}, "Hello!")
	}
}