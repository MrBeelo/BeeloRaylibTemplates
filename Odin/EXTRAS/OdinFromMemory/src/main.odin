package main

import rl "vendor:raylib"
import "core:math"
import "core:strings"
import "core:fmt"

TEMP_PATH :: "from-memory-temp"

should_close := false
window_size :: [2]i32{800, 450}

camera: rl.Camera3D
model: rl.Model
shader: rl.Shader
render: rl.RenderTexture

init :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(window_size.x, window_size.y, "NickBallon")

	camera = { {0, 0.5, 0}, {1, 0.5, 1}, {0, 1, 0}, 60, .PERSPECTIVE }
	model = load_model_from_memory("../res/model.glb", TEMP_PATH)
	shader = load_shader_from_memory("../res/fisheye.fs")
	render = rl.LoadRenderTexture(window_size.x, window_size.y)
}

update :: proc() {
	rl.BeginTextureMode(render)
	rl.ClearBackground(rl.WHITE)
	rl.BeginMode3D(camera)

	rl.DrawGrid(100, 0.2)
	
	t := (math.sin(rl.GetTime() * 3) + 1) / 2 // 0 -> 1
	y := f32(t) / 2 // 0 -> 0.5
	rot := math.mod_f32(f32(rl.GetTime()) * 20, 360)
	rl.DrawModelEx(model, {3, y, 3}, {0, 1, 0}, rot, 0.15, rl.WHITE)
	
	rl.EndMode3D()
	rl.EndTextureMode()

	rl.BeginDrawing()
	
	rl.ClearBackground(rl.WHITE)
	rl.BeginShaderMode(shader)
	rl.DrawTextureRec(render.texture, {0, 0, f32(render.texture.width), -f32(render.texture.height)}, 0, rl.WHITE)
	rl.EndShaderMode()
    
    rl.EndDrawing()

    free_all(context.temp_allocator)
}

close :: proc() {
	rl.UnloadRenderTexture(render)
	rl.UnloadShader(shader)
	rl.UnloadModel(model)
	rl.CloseWindow() 
}

// Creates a temporary directory at temp_dir, writes a model in it (embedded in the program),
// reads it, and destroys the file and directory as needed.
load_model_from_memory :: proc($path: string, temp_dir: cstring) -> rl.Model {
	temp_dir_exists := rl.DirectoryExists(temp_dir)
	// If the directory doesn't exist, make it. Otherwise, it's
	// safe to operate on the already existing directory. This has a
	// small chance of overwriting existing files if it happens, so we
	// panic in that case.
	if !temp_dir_exists do rl.MakeDirectory(temp_dir)

	// Load the embedded model data.
	data := #load(path)

	// Used to get just the file name (last index)
	strs := strings.split(path, "/", context.temp_allocator)
	// Gets the new file directory, aka both the temp directory and the new file name.
	file_dir := rl.TextFormat("%s/temp-%s", temp_dir, strs[len(strs) - 1])

	fmt.printf("GAME: Loading temp file at %s\n", file_dir)
	if rl.FileExists(file_dir) do fmt.panicf("GAME: File at %s already exists, continuing would overwrite and delete it!\n", file_dir)

	// If all is good, save the embedded data onto a file in the temp directory.
	rl.SaveFileData(file_dir, &data[0], i32(len(data)))
	// Now we can load the model normally.
	new_model := rl.LoadModel(file_dir)

	// Remove the file, as the model has been fully created and it is no longer
	// needed. This would be catastrophic if we didn't add the panic case earlier.
	rl.FileRemove(file_dir)
	// If the directory was just created (it didn't exist before this function), then
	// delete it. Doing this without checking if it existed would be bad, as the directory
	// would be removed no matter what.
	if !temp_dir_exists do rl.FileRemove(temp_dir)
	
	return new_model
}

// Loads a shader from memory, is a procedure group because sometimes
// loading a vertex shader is unnecessary.
load_shader_from_memory :: proc {
	load_fragment_shader_from_memory,
	load_multi_shader_from_memory,
}

load_fragment_shader_from_memory :: proc($path: string) -> rl.Shader {
	data := #load(path)
	str := cstring(&data[0])
	return rl.LoadShaderFromMemory(nil, str)
}

load_multi_shader_from_memory :: proc($vs_path, $fs_path: string) -> rl.Shader {
	vs_data := #load(vs_path)
	fs_data := #load(fs_path)
	vs_str := cstring(&vs_data[0])
	fs_str := cstring(&fs_data[0])
	return rl.LoadShaderFromMemory(vs_str, fs_str)
}