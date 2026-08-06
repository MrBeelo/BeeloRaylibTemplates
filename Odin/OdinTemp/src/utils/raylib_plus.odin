// raylib_plus serves as a collection of functions that expand raylib's library.

package utils

import rl "vendor:raylib"
import "core:strings"
import "core:unicode/utf8"
import "core:strconv"

// LOADING RELATED FUNCTIONS

// Loads a sound from memory by loading a wave from memory first,
// then importing a sound from it and deleting it.
LoadSoundFromMemory :: proc($path: string) -> rl.Sound {
	data := #load(path)

	strs := strings.split(path, ".")
	raw_extension := strs[len(strs) - 1]
	extension := rl.TextFormat(".%s", raw_extension)
	
	wave := rl.LoadWaveFromMemory(extension, &data[0], i32(len(data)))
	sound := rl.LoadSoundFromWave(wave)
	rl.UnloadWave(wave)
	return sound
}

// Same as LoadSoundFromMemory, but with Texture and Image.
LoadTextureFromMemory :: proc($path: string) -> rl.Texture {
	data := #load(path)

	strs := strings.split(path, ".")
	raw_extension := strs[len(strs) - 1]
	extension := rl.TextFormat(".%s", raw_extension)
	
	image := rl.LoadImageFromMemory(extension, &data[0], i32(len(data)))
	texture := rl.LoadTextureFromImage(image)
	rl.UnloadImage(image)
	return texture
}

// Creates a temporary directory at temp_dir, writes a model in it (embedded in the program),
// reads it, and destroys the file and directory as needed.
LoadModelFromMemory :: proc($path: string, temp_dir: cstring) -> rl.Model {
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
LoadShaderFromMemory :: proc {
	LoadFragmentShaderFromMemory,
	LoadMultiShaderFromMemory,
}

@(private = "file")
LoadFragmentShaderFromMemory :: proc($path: string) -> rl.Shader {
	data := #load(path)
	str := cstring(&data[0])
	return rl.LoadShaderFromMemory(nil, str)
}

@(private = "file")
LoadMultiShaderFromMemory :: proc($vs_path, $fs_path: string) -> rl.Shader {
	vs_data := #load(vs_path)
	fs_data := #load(fs_path)
	vs_str := cstring(&vs_data[0])
	fs_str := cstring(&fs_data[0])
	return rl.LoadShaderFromMemory(vs_str, fs_str)
}

// TEXT RELATED FUNCTIONS

DrawTextStyled :: proc(font: rl.Font, text: string, position: rl.Vector2, font_size: f32, spacing: f32, color: rl.Color) {
	text_len := len(text)

	col_front := color
	col_back := rl.BLANK
	back_rec_padding := 4

	text_offset_y, text_offset_x, text_line_spacing: f32
	scale_factor := font_size / f32(font.baseSize)

	for i := 0; i < text_len; {
		codepoint, codepoint_byte_count := utf8.decode_rune(text[i:])

		if codepoint == '\n' {
			text_offset_y += font_size + text_line_spacing
			text_offset_x = 0
		} else {
			if codepoint == '[' {
				if ((i + 2) < text_len) && (text[i + 1] == 'r') && (text[i + 2] == ']') {
                    col_front = color
                    col_back = rl.BLANK

                    i += 3
                    continue
                } else if (((i + 1) < text_len) && ((text[i + 1] == 'c') || (text[i + 1] == 'b'))) {
                	i += 2
                 	col_hex_text: [9]rune
                  	text_ptr := text[i:]

                   	col_hex_count := 0
                    for text_ptr[col_hex_count] != 0 && text_ptr[col_hex_count] != ']' {
                    	if IsValidStyleChar(text_ptr[col_hex_count]) {
                     		col_hex_text[col_hex_count] = rune(text_ptr[col_hex_count])
                       		col_hex_count += 1
                     	} else do break
                    }

                    col_hex_value, _ := strconv.parse_uint(utf8.runes_to_string(col_hex_text[:], context.temp_allocator), 16)
                    if text[i - 1] == 'c' {
                   		col_front = rl.GetColor(u32(col_hex_value))
                    } else if text[i - 1] == 'b' {
                   		col_back = rl.GetColor(u32(col_hex_value))
                    }

                    i += (col_hex_count + 1)
                    continue
                }
			}

			index := rl.GetGlyphIndex(font, codepoint)
			increase_x: f32

			if font.glyphs[index].advanceX == 0 {
				increase_x = font.recs[index].width * scale_factor + spacing
			} else {
				increase_x += f32(font.glyphs[index].advanceX) * scale_factor + spacing
			}

			if col_back.a > 0 do rl.DrawRectangleRec({position.x + text_offset_x, position.y + text_offset_y - f32(back_rec_padding),
				increase_x, font_size + 2 * f32(back_rec_padding)}, col_back)

			if codepoint != ' ' && codepoint != '\t' {
				rl.DrawTextCodepoint(font, codepoint, { position.x + text_offset_x, position.y + text_offset_y }, font_size, col_front)
			}

			text_offset_x += increase_x
		}

		i += codepoint_byte_count
	}
}

MeasureTextStyled :: proc(font: rl.Font, text: string, font_size: f32, spacing: f32) -> rl.Vector2 {
	text_size: rl.Vector2

	if len(text) <= 0 || text[0] == 0 do return text_size

	text_len := len(text)

	text_width: f32
	text_height := font_size
	scale_factor := font_size / f32(font.baseSize)

	index := 0
	valid_codepoint_counter := 0

	for i := 0; i < text_len; {
		codepoint, codepoint_byte_count := utf8.decode_rune(text[i:])

		if codepoint == '[' {
            if (i + 2) < text_len && text[i + 1] == 'r' && text[i + 2] == ']' {
                i += 3
                continue
            } else if (i + 1) < text_len && (text[i + 1] == 'c' || text[i + 1] == 'b') {
                i += 2

                text_ptr := text[i:]

                col_hex_count := 0
                for text_ptr[col_hex_count] != 0 && text_ptr[col_hex_count] != ']' {
                	if IsValidStyleChar(text_ptr[col_hex_count]) do col_hex_count += 1; else do break
                }

                i += (col_hex_count + 1)
                continue
            }
        } else if codepoint != '\n' {
            index = int(rl.GetGlyphIndex(font, codepoint))

            if font.glyphs[index].advanceX > 0 {
                text_width += f32(font.glyphs[index].advanceX)
            } else { 
                text_width += font.recs[index].width + f32(font.glyphs[index].offsetX)
            }

            valid_codepoint_counter += 1
            i += codepoint_byte_count
        }
	}

	text_size.x = text_width * scale_factor + (f32(valid_codepoint_counter) - 1) * spacing
    text_size.y = text_height

    return text_size
}

@(private = "file")
IsValidStyleChar :: proc(char: u8) -> bool {
	return (char >= '0' && char <= '9') || 
		(char >= 'A' && char <= 'F') ||
        (char >= 'a' && char <= 'f')
}

// RESOURCE RELATED FUNCTIONS

SearchAndSetResourceDir :: proc(folder_name: cstring) -> bool {
	if rl.DirectoryExists(folder_name) {
		rl.ChangeDirectory(folder_name)
		return true
	}
	
	app_dir := rl.GetApplicationDirectory()
	if ChangeAndCheckDir(rl.TextFormat("%s%s", app_dir, folder_name)) do return true
	if ChangeAndCheckDir(rl.TextFormat("%s../%s", app_dir, folder_name)) do return true
	if ChangeAndCheckDir(rl.TextFormat("%s../../%s", app_dir, folder_name)) do return true
	if ChangeAndCheckDir(rl.TextFormat("%s../../../%s", app_dir, folder_name)) do return true
	
	return false
}

@(private = "file")
ChangeAndCheckDir :: proc(dir: cstring) -> bool {
	if rl.DirectoryExists(dir) {
		rl.ChangeDirectory(dir)
		return true
	}
	return false
}