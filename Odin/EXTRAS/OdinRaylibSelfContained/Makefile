#------------------#
#     SETTINGS     #
#------------------#

# The executable's name. (without any extensions)
EXECUTABLE_NAME ?= OdinTempSelfContained

# Adds the .exe extension to the executable. Definitely use if on windows.
ADD_EXE ?= false

# Run the project immediately after export?
RUN ?= true

# Type of optimization to use. Options: none, minimal, size, speed, aggressive
OPTIMIZATION ?= none

# Enforce strict odin writing conventions?
STRICT ?= false

# Enable debug? (adds debug symbols and runs with gdb, if it exists)
DEBUG ?= false

# Copy resources over to the output directory? (desktop only)
COPY_RESOURCES ?= true

# Directory in which there are source files.
SOURCE_DIRECTORY ?= src

# Directory in which there are resources. (like images, sounds, etc.)
RESOURCES_DIRECTORY ?= res

# Directory in which the program along with the resources will be outputted in.
OUTPUT_DIRECTORY ?= bin

#----------------#
#     SCRIPT     #
#----------------#

# Add the strict flag if STRICT is true.
STRICT_FLAG := $(if $(filter true,$(STRICT)),-vet -strict-style)

# Ditto with DEBUG.
DEBUG_FLAG := $(if $(filter true,$(DEBUG)),-debug)

# Add .exe extension.
ifeq ($(ADD_EXE), true)
	EXECUTABLE_NAME := $(EXECUTABLE_NAME).exe
endif

# Decide whether the program should be run with gdb.
CAN_RUN_DEBUG := true
ifneq ($(DEBUG), true)
	CAN_RUN_DEBUG = false
endif
ifeq (, $(shell which gdb))
	CAN_RUN_DEBUG = false
endif

# Desktop Build
build:
	# Make the output directory if it doesn't already exist.
	mkdir -p $(OUTPUT_DIRECTORY)

	# Build command.
	odin build $(SOURCE_DIRECTORY) -out:$(OUTPUT_DIRECTORY)/$(EXECUTABLE_NAME) -o:$(OPTIMIZATION) $(STRICT_FLAG) $(DEBUG_FLAG)

# Copy the resources to the output directory. If this wasn't done, the user
# would have to manually copy over the resource folder to the final build.
ifeq ($(COPY_RESOURCES), true)
	cp -r $(RESOURCES_DIRECTORY) $(OUTPUT_DIRECTORY)
endif

# If RUN is set to true, run the program.
ifeq ($(RUN), true)

# Attempt to debug with gdb if it exists.
ifeq ($(CAN_RUN_DEBUG), true)
	gdb -q -ex 'set pagination off' ./$(OUTPUT_DIRECTORY)/$(EXECUTABLE_NAME) -ex 'set debuginfod enabled on' -ex run
else
	./$(OUTPUT_DIRECTORY)/$(EXECUTABLE_NAME)
endif

endif

# Clean the output directory.
# Can be called with 'make clean'.
clean:
	rm -rf $(OUTPUT_DIRECTORY)