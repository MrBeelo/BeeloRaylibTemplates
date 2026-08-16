package main

// STRUCTS / ENUMS //

ConfigFlag :: enum u32 {
	VSYNC_HINT               = 6,  // Set to try enabling V-Sync on GPU
	FULLSCREEN_MODE          = 1,  // Set to run program in fullscreen
	WINDOW_RESIZABLE         = 2,  // Set to allow resizable window
	WINDOW_UNDECORATED       = 3,  // Set to disable window decoration (frame and buttons)
	WINDOW_HIDDEN            = 7,  // Set to hide window
	WINDOW_MINIMIZED         = 9,  // Set to minimize window (iconify)
	WINDOW_MAXIMIZED         = 10, // Set to maximize window (expanded to monitor)
	WINDOW_UNFOCUSED         = 11, // Set to window non focused
	WINDOW_TOPMOST           = 12, // Set to window always on top
	WINDOW_ALWAYS_RUN        = 8,  // Set to allow windows running while minimized
	WINDOW_TRANSPARENT       = 4,  // Set to allow transparent framebuffer
	WINDOW_HIGHDPI           = 13, // Set to support HighDPI
	WINDOW_MOUSE_PASSTHROUGH = 14, // Set to support mouse passthrough, only supported when FLAG_WINDOW_UNDECORATED
	BORDERLESS_WINDOWED_MODE = 15, // Set to run program in borderless windowed mode
	MSAA_4X_HINT             = 5,  // Set to try enabling MSAA 4X
	INTERLACED_HINT          = 16, // Set to try enabling interlaced video format (for V3D)
}

ConfigFlags :: bit_set[ConfigFlag; u32]

PixelFormat :: enum u32 {
	UNCOMPRESSED_GRAYSCALE    = 1,  // 8 bit per pixel (no alpha)
	UNCOMPRESSED_GRAY_ALPHA   = 2,  // 8*2 bpp (2 channels)
	UNCOMPRESSED_R5G6B5       = 3,  // 16 bpp
	UNCOMPRESSED_R8G8B8       = 4,  // 24 bpp
	UNCOMPRESSED_R5G5B5A1     = 5,  // 16 bpp (1 bit alpha)
	UNCOMPRESSED_R4G4B4A4     = 6,  // 16 bpp (4 bit alpha)
	UNCOMPRESSED_R8G8B8A8     = 7,  // 32 bpp
	UNCOMPRESSED_R32          = 8,  // 32 bpp (1 channel - float)
	UNCOMPRESSED_R32G32B32    = 9,  // 32*3 bpp (3 channels - float)
	UNCOMPRESSED_R32G32B32A32 = 10, // 32*4 bpp (4 channels - float)
	UNCOMPRESSED_R16          = 11, // 16 bpp (1 channel - half float)
	UNCOMPRESSED_R16G16B16    = 12, // 16*3 bpp (3 channels - half float)
	UNCOMPRESSED_R16G16B16A16 = 13, // 16*4 bpp (4 channels - half float)
	COMPRESSED_DXT1_RGB       = 14, // 4 bpp (no alpha)
	COMPRESSED_DXT1_RGBA      = 15, // 4 bpp (1 bit alpha)
	COMPRESSED_DXT3_RGBA      = 16, // 8 bpp
	COMPRESSED_DXT5_RGBA      = 17, // 8 bpp
	COMPRESSED_ETC1_RGB       = 18, // 4 bpp
	COMPRESSED_ETC2_RGB       = 19, // 4 bpp
	COMPRESSED_ETC2_EAC_RGBA  = 20, // 8 bpp
	COMPRESSED_PVRT_RGB       = 21, // 4 bpp
	COMPRESSED_PVRT_RGBA      = 22, // 4 bpp
	COMPRESSED_ASTC_4x4_RGBA  = 23, // 8 bpp
	COMPRESSED_ASTC_8x8_RGBA  = 24, // 2 bpp
}

Texture :: struct {
	id:      u32,      // OpenGL texture id
	width:   i32,       // Texture base width
	height:  i32,       // Texture base height
	mipmaps: i32,       // Mipmap levels, 1 by default
	format:  PixelFormat, // Data format (PixelFormat type)
}

Texture2D :: Texture

Rectangle :: struct {
	x:      f32, // Rectangle top-left corner position x
	y:      f32, // Rectangle top-left corner position y
	width:  f32, // Rectangle width
	height: f32, // Rectangle height
}

Color :: distinct [4]u8

WHITE :: (Color){255, 255, 255, 255}
RAYWHITE :: (Color){245, 245, 245, 255}
LIGHTGRAY :: (Color){200, 200, 200, 255}

// FOREIGN FUNCTIONS //

@(default_calling_convention="c")
foreign raylib {
	InitWindow :: proc(width, height: i32, title: cstring) ---
	CloseWindow :: proc() ---
	SetConfigFlags :: proc(flags: ConfigFlags) ---
	
	LoadTexture :: proc(fileName: cstring) -> Texture2D ---
	UnloadTexture :: proc(texture: Texture2D) ---
	DrawTexture :: proc(texture: Texture2D, posX, posY: i32, tint: Color) ---

	DrawText :: proc(text: cstring, posX, posY: i32, fontSize: i32, color: Color) ---
	
	WindowShouldClose :: proc() -> bool ---
	BeginDrawing :: proc() ---
	EndDrawing :: proc() ---
	ClearBackground :: proc(color: Color) ---
}

@(default_calling_convention="c")
foreign raygui {
	GuiButton :: proc(bounds: Rectangle, text: cstring) -> i32 --- 
}

// IMPORTS //

RAYLIB_SHARED :: #config(RAYLIB_SHARED, false)
RAYLIB_WASM_LIB :: #config(RAYLIB_WASM_LIB, "../lib/webassembly/libraylib.web.a")
RAYGUI_SHARED :: #config(RAYGUI_SHARED, false)
RAYGUI_WASM_LIB :: #config(RAYGUI_WASM_LIB, "../lib/webassembly/libraygui.web.a")

when ODIN_OS == .Windows {
	@(extra_linker_flags="/NODEFAULTLIB:" + ("msvcrt" when RAYLIB_SHARED else "libcmt"))
	foreign import raylib {
		(
			"../lib/win64_msvc16/raylibdll.lib" when RAYLIB_SHARED && ODIN_ARCH == .amd64 else 
			"../lib/win64_msvc16/raylib.lib" when ODIN_ARCH == .amd64 else 
			"../lib/win32_msvc16/raylibdll.lib" when RAYLIB_SHARED && ODIN_ARCH == .i386 else 
			"../lib/win32_msvc16/raylib.lib" when ODIN_ARCH == .i386 else 
			"../lib/winarm64_msvc16/raylibdll.lib" when RAYLIB_SHARED && ODIN_ARCH == .arm64 else 
			"../lib/winarm64_msvc16/raylib.lib" when ODIN_ARCH == .arm64 else
			"system:raylib"
		),
		"system:Winmm.lib",
		"system:Gdi32.lib",
		"system:User32.lib",
		"system:Shell32.lib",
	}
} else when ODIN_OS == .Linux {
	// Note(bumbread): I'm not sure why in `linux/` folder there are
	// multiple copies of raylib.so, but since these bindings are for
	// particular version of the library, I better specify it. Ideally,
	// though, it's best specified in terms of major (.so.4)
	foreign import raylib {
		(
			"../lib/linux_amd64/libraylib.so.600" when RAYLIB_SHARED && ODIN_ARCH == .amd64 else 
			"../lib/linux_amd64/libraylib.a" when ODIN_ARCH == .amd64 else 
			"../lib/linux_i386/libraylib.a" when ODIN_ARCH == .i386 else 
			"../lib/linux_arm64/libraylib.so.600" when RAYLIB_SHARED && ODIN_ARCH == .arm64 else 
			"../lib/linux_arm64/libraylib.a" when ODIN_ARCH == .arm64 else
			"system:raylib"
		),
		"system:dl",
		"system:pthread",
		"system:X11",
	}
} else when ODIN_OS == .Darwin {
	foreign import raylib {
		"../lib/macos/libraylib.600.dylib" when RAYLIB_SHARED else "../lib/macos/libraylib.a",
		"system:Cocoa.framework",
		"system:OpenGL.framework",
		"system:IOKit.framework",
	}
} else when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
	foreign import raylib {
		RAYLIB_WASM_LIB,
	}
} else {
	foreign import raylib "system:raylib"
}

when ODIN_OS == .Windows {
	foreign import raygui {
		(
			"../lib/win64_msvc16/rayguidll.lib" when RAYGUI_SHARED && ODIN_ARCH == .amd64 else 
			"../lib/win64_msvc16/raygui.lib" when ODIN_ARCH == .amd64 else 
			"../lib/win32_msvc16/rayguidll.lib" when RAYGUI_SHARED && ODIN_ARCH == .i386 else 
			"../lib/win32_msvc16/raygui.lib" when ODIN_ARCH == .i386 else 
			"../lib/winarm64_msvc16/rayguidll.lib" when RAYGUI_SHARED && ODIN_ARCH == .arm64 else 
			"../lib/winarm64_msvc16/raygui.lib" when ODIN_ARCH == .arm64 else
			"system:raygui"
		),
	}
} else when ODIN_OS == .Linux {
	// Note(bumbread): I'm not sure why in `linux/` folder there are
	// multiple copies of raygui.so, but since these bindings are for
	// particular version of the library, I better specify it. Ideally,
	// though, it's best specified in terms of major (.so.4)
	foreign import raygui {
		(
			"../lib/linux_amd64/libraygui.so.5.0.0" when RAYGUI_SHARED && ODIN_ARCH == .amd64 else 
			"../lib/linux_amd64/libraygui.a" when ODIN_ARCH == .amd64 else 
			"../lib/linux_i386/libraygui.a" when ODIN_ARCH == .i386 else 
			"../lib/linux_arm64/libraygui.so.5.0.0" when RAYGUI_SHARED && ODIN_ARCH == .arm64 else 
			"../lib/linux_arm64/libraygui.a" when ODIN_ARCH == .arm64 else
			"system:raygui"
		),
	}
} else when ODIN_OS == .Darwin {
	foreign import raygui {
		"../lib/macos/libraygui.5.0.0.dylib" when RAYGUI_SHARED else "../lib/macos/libraygui.a",
	}
} else when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
	foreign import raygui {
		RAYGUI_WASM_LIB,
	}
} else {
	foreign import raygui "system:raygui"
}