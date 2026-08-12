// raylib_odin serves as a collection of raylib functions that better suit odin.
// For instance, the text drawing functions here take strings instead of cstrings.

package utils

import rl "../raylib"
import "../raylib/rlgl"
import "core:unicode/utf8"

// TEXT RELATED FUNCTIONS

@(private = "file") text_line_spacing := f32(2)

DrawTextEx :: proc(font: rl.Font, text: string, position: rl.Vector2, font_size: f32, spacing: f32, tint: rl.Color) {
	font := font if font.texture.id != 0 else rl.GetFontDefault()
	
	size := len(text)
	
	text_offset: rl.Vector2
	
	scale_factor := font_size / f32(font.baseSize)

	for i := 0; i < size; {
		codepoint, codepoint_byte_count := utf8.decode_rune(text[i:])
		index := rl.GetGlyphIndex(font, codepoint)
		
		if codepoint == '\n' {
			text_offset.y += (font_size + text_line_spacing)
			text_offset.x = 0
		} else {
			if codepoint != ' ' && codepoint != '\t' {
				rl.DrawTextCodepoint(font, codepoint, position + text_offset, font_size, tint)
			}

			if font.glyphs[index].advanceX == 0 {
				text_offset.x += (font.recs[index].width * scale_factor + spacing)
			} else {
				text_offset.x += (f32(font.glyphs[index].advanceX) * scale_factor + spacing)
			}
		}

		i += codepoint_byte_count
	}
}

DrawTextPro :: proc(font: rl.Font, text: string, position: rl.Vector2, origin: rl.Vector2, rotation: f32, font_size: f32, spacing: f32, tint: rl.Color) {
	rlgl.PushMatrix()

	rlgl.Translatef(position.x, position.y, 0)
	rlgl.Rotatef(rotation, 0, 0, 1)
	rlgl.Translatef(-origin.x, -origin.y, 0)
	DrawTextEx(font, text, 0, font_size, spacing, tint)

	rlgl.PopMatrix()
}

MeasureTextEx :: proc(font: rl.Font, text: string, font_size: f32, spacing: f32) -> rl.Vector2 {
	text_size: rl.Vector2

	if font.texture.id == 0 || len(text) == 0 || text[0] == 0 do return text_size

	size := len(text)
	temp_byte_counter := 0
	byte_counter := 0

	text_width := f32(0)
	temp_text_width := f32(0)

	text_height := font_size
	scale_factor := font_size / f32(font.baseSize)

	letter: rune
	index := 0

	for i := 0; i < size; {
		byte_counter += 1

		codepoint_byte_count := 0
		letter, codepoint_byte_count = utf8.decode_rune(text[i:])
		index = int(rl.GetGlyphIndex(font, letter))

		i += codepoint_byte_count

		if letter != '\n' {
			if font.glyphs[index].advanceX > 0 {
				text_width += f32(font.glyphs[index].advanceX)
			} else {
				text_width += (font.recs[index].width + f32(font.glyphs[index].offsetX))
			}
		} else {
			if temp_text_width < text_width do temp_text_width = text_width
			byte_counter = 0
			text_width = 0

			text_height += (font_size + text_line_spacing)
		}

		if temp_byte_counter < byte_counter do temp_byte_counter = byte_counter
	}

	if temp_text_width < text_width do temp_text_width = text_width

	text_size.x = temp_text_width * scale_factor + (f32(temp_byte_counter) - 1) * spacing
	text_size.y = text_height

	return text_size
}

SetTextLineSpacing :: proc(spacing: int) {
	text_line_spacing = f32(spacing)
	rl.SetTextLineSpacing(i32(spacing))
}