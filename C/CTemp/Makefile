# MrBeelo's *basic* C template!
# 
# A more complex C template that uses Zig's build system can be found at CTempZBS
# This version uses precompiled raylib binaries (libraylib.a), that can be found
# on the releases page of Raylib's GitHub.
# 
# You will need the following compilers:
# Windows, Linux -> gcc
# MacOS -> clang
# WebAssembly -> emcc
# 
# Note 1: This currently only builds a single file (set to main.c but can be changed)
# Support for more files may be added in the future. The idea is that all other
# C files are #included in the main one.
# 
# Note 2: C++ support hasn't been added yet.
# 
# Note 3: WebAssembly is supported, but it uses ASYNCIFY to dumb down the process.
# I think it's worth it, even though there might be a performace hit...

#--SETTINGS--

# Basic Settings

# Options can be found as the different folders of the lib/ directory.
TARGET_PLATFORM := linux_amd64

# This should be standalone, no matter the operating system, as it will be changed later (no .<suffix>)
BASE_EXECUTABLE_NAME := CTemp

# Run the program immediately after exporting?
RUN := true

# Compiler flags to pass.
# -Os optimizes code for size.
# -std=c99 sets the C version to c99, it can also be set to c89, c11, or c23.
# -Wall enables compiler warnings. -Werror can also be set to treat them as errors.
COMPILER_FLAGS := -Os -std=c99 -Wall

# Directory Settings
# These don't need to be changed with the current folder structure!

SOURCE_DIR := src
MAIN_FILE := $(SOURCE_DIR)/main.c
RESOURCE_DIR := res
INCLUDE_DIR := $(SOURCE_DIR)/incl
BASE_LIBRARY_DIR := lib
BASE_OUTPUT_DIR := bin

# Used to differentiate between builds from different platforms.
LIBRARY_DIR := $(BASE_LIBRARY_DIR)/$(TARGET_PLATFORM)
OUTPUT_DIR := $(BASE_OUTPUT_DIR)/$(TARGET_PLATFORM)
WEB_SHELL_DIR := $(RESOURCE_DIR)/shell.html

#--SCRIPT--

# Note: these are just placeholders, they will be changed depending on the platform.
COMPILER := gcc
LIBRARY_FLAGS := -lraylib

# This will be changed on the platforms that need an extra suffix (like windows and webassembly).
EXECUTABLE_NAME = $(BASE_EXECUTABLE_NAME)

# Used for webassembly only.
WEB_LIBRARY :=

# Change compiler and flags for windows.
ifeq ($(TARGET_PLATFORM), $(filter $(TARGET_PLATFORM), win32_mingw-w64 win64_mingw-w64))
	COMPILER = gcc
	LIBRARY_FLAGS = -lraylib -lopengl32 -lgdi32 -lwinmm -lmingw32
	EXECUTABLE_NAME = $(BASE_EXECUTABLE_NAME).exe
endif

# Change compiler and flags for macos.
# Not tested well, may not work! (I don't have an apple machine...)
ifeq ($(TARGET_PLATFORM), macos)
	COMPILER = clang
	LIBRARY_FLAGS = -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL
endif

# Change compiler and flags for linux.
ifeq ($(TARGET_PLATFORM), $(filter $(TARGET_PLATFORM), linux_amd64 linux_arm64 linux_i386))
	COMPILER = gcc
	LIBRARY_FLAGS = -lraylib -lGL -lm -lpthread -ldl -lrt -lX11
endif

# Change compiler and flags for webassembly.
ifeq ($(TARGET_PLATFORM), webassembly)
	COMPILER = emcc
	LIBRARY_FLAGS = -s USE_GLFW=3 -s ASYNCIFY -s ALLOW_MEMORY_GROWTH=1 --shell-file $(WEB_SHELL_DIR) --preload-file $(RESOURCE_DIR)
	WEB_LIBRARY = $(LIBRARY_DIR)/libraylib.web.a
	EXECUTABLE_NAME = $(BASE_EXECUTABLE_NAME).html
endif

# Build the program
build:
	# Make the output directory if it doesn't already exist.
	mkdir -p $(OUTPUT_DIR)

	# Build command.
	$(COMPILER) $(MAIN_FILE) -o $(OUTPUT_DIR)/$(EXECUTABLE_NAME) $(COMPILER_FLAGS) $(WEB_LIBRARY) -I $(INCLUDE_DIR) -L $(LIBRARY_DIR) $(LIBRARY_FLAGS)

# Copy the resource directory to the output directory.
# This is useful when compressing the game for release,
# as the user would have to manually copy the resource folder.
# Of course, this has no reason to be done in WebAssembly
ifneq ($(TARGET_PLATFORM), webassembly)
	cp -r $(RESOURCE_DIR) $(OUTPUT_DIR)
endif

# If on WebAssembly, rename the generated html file to index.html.
# This is done because otherwise we would have to specify the html file
# every time we ran a web server (and itch.io needs it).
ifeq ($(TARGET_PLATFORM), webassembly)
	mv $(OUTPUT_DIR)/$(EXECUTABLE_NAME) $(OUTPUT_DIR)/index.html
endif

# Run the program if RUN is set to true.
ifeq ($(RUN), true)

ifneq ($(TARGET_PLATFORM), webassembly)
	# Non-WebAssembly: Just run the application.
	./$(OUTPUT_DIR)/$(EXECUTABLE_NAME)
else
	# WebAssembly: Run a python server on the output directory.
	cd $(OUTPUT_DIR) && python -m http.server 8080
endif

endif

# Remove the output directory.
# Can be called with 'make clean'.
clean:
	rm -r $(BASE_OUTPUT_DIR)