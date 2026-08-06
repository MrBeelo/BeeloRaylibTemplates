package desktop

import rl "vendor:raylib"
import game ".."

main :: proc() {
	context.allocator = heap_allocator()
	game.init()
	for !rl.WindowShouldClose() && !game.should_close do game.update()
	game.close()
}