# MrBeelo's *basic* C template!
# A more complex C template that uses Zig's build system can be found at CTempZBS
# This version uses precompiled raylib binaries (libraylib.a), that can be found
# on the releases page of Raylib's GitHub.
# 
# Note 1: This currently only builds a single file (set to main.c but can be changed)
#         Support for more files may be added in the future.
#         The idea is that all other C files are #included in the main one.
# 
# Note 2: Even though I have the binaries for it, WebAssembly isn't supported yet.
# 
# Note 3: C++ support hasn't been added yet.
# 
# All of these features will be added in the future :D

#--SETTINGS--

# Basic Settings

# Options can be found as the different folders of the lib/ directory.
TARGET_PLATFORM := linux_amd64

# Don't forget to add .exe on the end if on windows!
EXECUTABLE_NAME := CTemp

# Run the program immediately after exporting?
RUN := true

# Compiler flags to pass.
# -std=c99 sets the C version to c99, it can also be set to c89, c11, or c23.
# -Wall enables compiler warnings. -Werror can also be set to treat them as errors.
COMPILER_FLAGS := -std=c99 -Wall

# Directory Settings
# These don't need to be changed with the current folder structure!

SOURCE_DIR := src
MAIN_FILE := $(SOURCE_DIR)/main.c
RESOURCE_DIR := res
INCLUDE_DIR := $(SOURCE_DIR)/incl
BASE_LIBRARY_DIR := lib
BASE_OUTPUT_DIR := bin

#--SCRIPT--

# Used to differentiate between builds from different platforms.
LIBRARY_DIR := $(BASE_LIBRARY_DIR)/$(TARGET_PLATFORM)
OUTPUT_DIR := $(BASE_OUTPUT_DIR)/$(TARGET_PLATFORM)

# Note: these are just placeholders, they will be changed depending on the platform.
COMPILER := gcc
LIBRARY_FLAGS := -lraylib

# Change compiler and flags for windows.
ifeq ($(TARGET_PLATFORM), $(filter $(TARGET_PLATFORM), win32_mingw-w64 win64_mingw-w64))
	COMPILER = gcc
	LIBRARY_FLAGS = -lraylib -lopengl32 -lgdi32 -lwinmm -lmingw32
endif

# Change compiler and flags for macos.
# Not tested well, may not work! (I don't have an apple machine...)
ifeq ($(TARGET_PLATFORM), macos)
	COMPILER = clang
	LIBRARY_FLAGS = -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL libraylib.a
endif

# Change compiler and flags for linux.
ifeq ($(TARGET_PLATFORM), $(filter $(TARGET_PLATFORM), linux_amd64 linux_arm64 linux_i386))
	COMPILER = gcc
	LIBRARY_FLAGS = -lraylib -lGL -lm -lpthread -ldl -lrt -lX11
endif

# Build the program
build:
	# Make the output directory if it doesn't already exist.
	@mkdir -p $(OUTPUT_DIR)

	# Copy the resource directory to the output directory.
	# This is useful when compressing the game for release,
	# as the user would have to manually copy the resource folder.
	@cp -r $(RESOURCE_DIR) $(OUTPUT_DIR)

	# Build command.
	$(COMPILER) $(MAIN_FILE) -o $(OUTPUT_DIR)/$(EXECUTABLE_NAME) $(COMPILER_FLAGS) -I $(INCLUDE_DIR) -L $(LIBRARY_DIR) $(LIBRARY_FLAGS)

# Run the program if RUN is set to true.
ifeq ($(RUN), true)
	./$(OUTPUT_DIR)/$(EXECUTABLE_NAME)
endif

# Remove the output directory.
clean:
	rm -r $(BASE_OUTPUT_DIR)