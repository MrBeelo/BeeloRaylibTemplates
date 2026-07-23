#--SETTINGS--

# Directory in which there are source files.
SOURCE_DIRECTORY := src

# Directory in which there are resources (like images, sounds, etc.).
RESOURCES_DIRECTORY := res

# Directory in which the program along with the resources will be outputted in.
OUTPUT_DIRECTORY := bin

# The executable's name (add .exe if on windows)
EXECUTABLE_NAME := OdinRayGui

# Run the project immediately after export?
RUN := true

# Type of optimization to use. Options: none, minimal, size, speed, aggressive
OPTIMIZATION := none

# Enforce string odin writing conventions?
STRICT := true

#--SCRIPT--

STRICT_FLAG := $(if $(filter true,$(STRICT)),-vet -strict-style)

build:
	mkdir -p $(OUTPUT_DIRECTORY)
	odin build $(SOURCE_DIRECTORY) -out:$(OUTPUT_DIRECTORY)/$(EXECUTABLE_NAME) -o:$(OPTIMIZATION) $(STRICT_FLAG)
	cp -r $(RESOURCES_DIRECTORY) $(OUTPUT_DIRECTORY)

ifeq ($(RUN), true)
	./$(OUTPUT_DIRECTORY)/$(EXECUTABLE_NAME)
endif

clean:
	rm -rf $(OUTPUT_DIRECTORY)