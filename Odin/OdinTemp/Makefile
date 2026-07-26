#------------------#
#     SETTINGS     #
#------------------#

# Directory in which there are source files.
BASE_SOURCE_DIRECTORY := src

# Directory in which there are resources (like images, sounds, etc.).
RESOURCES_DIRECTORY := res

# Directory in which the program along with the resources will be outputted in.
BASE_OUTPUT_DIRECTORY := bin

# The executable's name (add .exe if on windows)
EXECUTABLE_NAME := OdinTemp

# Run the project immediately after export?
RUN := true

# Type of optimization to use. Options: none, minimal, size, speed, aggressive
OPTIMIZATION := none

# Enforce string odin writing conventions?
STRICT := true

# What should be the target? Options: desktop, web
MODE := desktop

# Odin's path. (needed for web building only)
ODIN_PATH := $(shell odin root)

#----------------#
#     SCRIPT     #
#----------------#

# This reroutes the source directory to a subfolder, as there are two 'main' procs.
SOURCE_DIRECTORY := $(BASE_SOURCE_DIRECTORY)/$(MODE)

# This is used for convenience if building on multiple platforms
OUTPUT_DIRECTORY := $(BASE_OUTPUT_DIRECTORY)/$(MODE)

# Add the strict flag if STRICT is true
STRICT_FLAG := $(if $(filter true,$(STRICT)),-vet -strict-style)

# Change the build target depending on the platform
build: build-$(MODE)

# Desktop Build
build-desktop:
	# Make the output directory if it doesn't already exist.
	mkdir -p $(OUTPUT_DIRECTORY)

	# Copy the resources to the output directory. If this wasn't done, the user
	# would have to manually copy over the resource folder to the final build.
	cp -r $(RESOURCES_DIRECTORY) $(OUTPUT_DIRECTORY)

	# Build command.
	odin build $(SOURCE_DIRECTORY) -out:$(OUTPUT_DIRECTORY)/$(EXECUTABLE_NAME) -o:$(OPTIMIZATION) $(STRICT_FLAG)	

# If RUN is set to true, run the program.
ifeq ($(RUN), true)
	./$(OUTPUT_DIRECTORY)/$(EXECUTABLE_NAME)
endif

# Additional build flags needed for web building. Generates an obj file that emscripten will take.
ODIN_WEB_BUILD_FLAGS = -target:js_wasm32 -build-mode:obj -define:RAYLIB_WASM_LIB=env.o -define:RAYGUI_WASM_LIB=env.o $(STRICT_FLAG) -out:$(OUTPUT_DIRECTORY)/game.wasm.obj

# Outputted obj file and raylib library.
WEB_FILES := $(OUTPUT_DIRECTORY)/game.wasm.obj $(ODIN_PATH)/vendor/raylib/wasm/libraylib.web.a $(ODIN_PATH)/vendor/raylib/wasm/libraygui.a

# Some additional flags for emscripten.
WEB_FLAGS := -sEXPORTED_RUNTIME_METHODS=['HEAPF32'] -sALLOW_MEMORY_GROWTH=1 -sUSE_GLFW=3 -sWASM_BIGINT -sWARN_ON_UNDEFINED_SYMBOLS=0 -sASSERTIONS --shell-file $(SOURCE_DIRECTORY)/shell.html --preload-file $(RESOURCES_DIRECTORY)

# Web build
build-web:
	# Make the output directory if it doesn't already exist.
	mkdir -p $(OUTPUT_DIRECTORY)

	# First pass: odin build command.
	odin build $(SOURCE_DIRECTORY) $(ODIN_WEB_BUILD_FLAGS)

	# Copy over odin.js to the output directory.
	cp $(ODIN_PATH)/core/sys/wasm/js/odin.js $(OUTPUT_DIRECTORY)

	# Second pass: emcc build command.
	emcc -o $(OUTPUT_DIRECTORY)/index.html $(WEB_FILES) $(WEB_FLAGS)

	# Since the project has been built, we can get rid of the obj file.
	rm $(OUTPUT_DIRECTORY)/game.wasm.obj

# If RUN is set to true, start a python server on the output directory.
ifeq ($(RUN), true)
	cd $(OUTPUT_DIRECTORY) && python -m http.server 8080
endif

# Clean the output directory.
# Can be called with 'make clean'.
clean:
	rm -rf $(BASE_OUTPUT_DIRECTORY)