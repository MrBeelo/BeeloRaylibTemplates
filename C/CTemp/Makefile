# MrBeelo's *basic* C template!
# 
# A more complex C template that uses Zig's build system can be found at CTempZBS
# This version uses precompiled raylib binaries (libraylib.a), that can be found
# on the releases page of Raylib's GitHub.
# 
# You will need the following compiler(s):
# Windows, Linux -> gcc
# MacOS -> clang
# WebAssembly -> emcc
# 
# Note: WebAssembly is supported, but it uses ASYNCIFY to dumb down the process.
# I think it's worth it, even though there might be a small performace hit...
# 
# Note: I included a .clangd file for the LSP. In it, remove the -xc flag if working
# with C++, and change the -I flag to change the include path as needed.
# (This is purely cosmetic, of course)

#------------------#
#     SETTINGS     #
#------------------#

# Basic Settings

# Options can be found as the different folders of the lib/ directory.
TARGET_PLATFORM := linux_amd64

# This should be standalone, no matter the operating system, as it will be changed later (no .<suffix>)
BASE_EXECUTABLE_NAME := CTemp

# Run the program immediately after exporting?
RUN := true

# Includes the C++ standard library, and changes the extension used to .cpp
USE_CPP := false

# Versions of C and C++ respectively to use.
C_VERSION := c99
CPP_VERSION := c++20

# Additional compiler flags to pass.
# -Os optimizes code for size.
# -Wall enables compiler warnings. -Werror can also be set to treat them as errors.
EXTRA_COMPILER_FLAGS := -Os -Wall

# Directory Settings

# Directory of all source files (.c / .cpp files).
SOURCE_DIR := src

# Directory of all resources. This will be copied over to the binary folder,
# or compiled into a .data file for webassembly.
RESOURCE_DIR := res

# Directory of raylib library (libraylib.a / libraylib.web.a file).
BASE_LIBRARY_DIR := lib

# Output directory.
BASE_OUTPUT_DIR := bin

# Directory of additional includes (.h / .hpp files).
INCLUDE_DIR := incl

# Shell directory. This is only used for webassembly.
WEB_SHELL := $(INCLUDE_DIR)/shell.html

#----------------#
#     SCRIPT     #
#----------------#

# Used to differentiate between builds from different platforms.
OUTPUT_DIR := $(BASE_OUTPUT_DIR)/$(TARGET_PLATFORM)

# This will be changed on webassembly (only really needed for webassembly and macos).
LIBRARY_DIR := $(BASE_LIBRARY_DIR)/$(TARGET_PLATFORM)

# Manage compiler flags and extension, and add C++ support if needed.
COMPILER_FLAGS := $(EXTRA_COMPILER_FLAGS)

# This will be changed if USE_CPP is true
EXTENSION := .c

ifeq ($(USE_CPP), true)
	COMPILER_FLAGS += -std=$(CPP_VERSION) -lstdc++ 
	EXTENSION = .cpp
else
	COMPILER_FLAGS += -std=$(C_VERSION)
	#EXTENSION = .c
endif

# Compiler to be used. This is going to be changed on macos and webassembly.
COMPILER := gcc

# Library flags. This is different on every platform, so it's a placeholder for now.
LIBRARY_FLAGS := -lraylib

# This will be changed on the platforms that need an extra suffix (like windows and webassembly).
EXECUTABLE_NAME = $(BASE_EXECUTABLE_NAME)

# Change compiler and library flags for windows.
ifeq ($(TARGET_PLATFORM), $(filter $(TARGET_PLATFORM), win32_mingw-w64 win64_mingw-w64))
	#COMPILER = gcc
	LIBRARY_FLAGS = -lraylib -lopengl32 -lgdi32 -lwinmm -lmingw32
	EXECUTABLE_NAME = $(BASE_EXECUTABLE_NAME).exe
endif

# Change compiler and library flags for macos.
# Not tested well, may not work! (I don't have an apple machine...)
ifeq ($(TARGET_PLATFORM), macos)
	COMPILER = clang
	LIBRARY_FLAGS = -lraylib -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL
	#EXECUTABLE_NAME = $(BASE_EXECUTABLE_NAME)
endif

# Change compiler and library flags for linux.
ifeq ($(TARGET_PLATFORM), $(filter $(TARGET_PLATFORM), linux_amd64 linux_arm64 linux_i386))
	#COMPILER = gcc
	LIBRARY_FLAGS = -lraylib -lGL -lm -lpthread -ldl -lrt -lX11
	#EXECUTABLE_NAME = $(BASE_EXECUTABLE_NAME)
endif

# Change compiler and library flags for webassembly.
ifeq ($(TARGET_PLATFORM), webassembly)
	COMPILER = emcc
	LIBRARY_FLAGS = -lraylib.web -s USE_GLFW=3 -s ASYNCIFY -s ALLOW_MEMORY_GROWTH=1 --shell-file $(WEB_SHELL) --preload-file $(WEB_SHELL) --preload-file $(RESOURCE_DIR)
	EXECUTABLE_NAME = $(BASE_EXECUTABLE_NAME).html
endif

# Build the program
build:
	# Make the output directory if it doesn't already exist.
	mkdir -p $(OUTPUT_DIR)

	# Build command.
	$(COMPILER) $(SOURCE_DIR)/*$(EXTENSION) -o $(OUTPUT_DIR)/$(EXECUTABLE_NAME) $(COMPILER_FLAGS) -I $(INCLUDE_DIR) -L $(LIBRARY_DIR) $(LIBRARY_FLAGS)

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

# Run the program in some way if RUN is set to true.
ifeq ($(RUN), true)

ifneq ($(TARGET_PLATFORM), webassembly)
	# Desktop: Just run the application.
	./$(OUTPUT_DIR)/$(EXECUTABLE_NAME)
else
	# WebAssembly: Run a python server on the output directory.
	cd $(OUTPUT_DIR) && emrun .
endif

endif

# Remove the output directory.
# Can be called with 'make clean'.
clean:
	rm -r $(BASE_OUTPUT_DIR)