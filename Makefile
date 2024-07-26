# Get Linux kernel version
LKER  := $(shell uname -r)
# Remove things like -default or -generic from the kernel version
LKER_BASE := $(shell echo $(LKER) | sed -e 's/-[a-zA-Z]\+//')
# Get the architecture of the kernel
LKARCH_R := $(shell uname -m)
# If it's x86_64 then we need to change it to x86
ifeq ($(LKARCH_R),x86_64)
LKARCH := x86
else
LKARCH := $(LKARCH_R)
endif

# Set default paths for kernel headers
KDIR   := /lib/modules/$(LKER)/build
KINC1  := /lib/modules/$(LKER)/source/include/linux
KINC2  := /usr/src/linux-$(LKER_BASE)/include/
KINC3  := /usr/src/linux-$(LKER_BASE)/include/
KARCH0 := /usr/src/linux-$(LKER_BASE)/arch/$(LKARCH)/include/
KARCH1 := /usr/src/linux-$(LKER_BASE)/arch/$(LKARCH)/include/
KARCH2 := /usr/src/linux-$(LKER_BASE)/arch/$(LKARCH)/include/generated/

# If we are on OpenSUSE, check if linux-<version>-obj exists, if it does use that for the kernel headers
# because all linux distros have to do their own thing (silly distros)
ifneq ($(wildcard /usr/src/linux-$(LKER_BASE)-obj/),)
KINC3  := /usr/src/linux-$(LKER_BASE)-obj/$(LKARCH_R)/default/include/
KARCH1 := /usr/src/linux-$(LKER_BASE)-obj/$(LKARCH_R)/default/arch/$(LKARCH)/include/
KARCH2 := /usr/src/linux-$(LKER_BASE)-obj/$(LKARCH_R)/default/arch/$(LKARCH)/include/generated/
endif

# Define variables
KERNEL_SRC_PATH ?= ./rust_module/kernel_path

## Output directory for the built module
BUILD_DIR := build

# The Rust project directory
RUST_DIR := rust_module

# The name of the generated module
MODULE_NAME := rust_hello

# Ensure the environment variable is exported for the build script
export KERNEL_SRC_PATH

.PHONY: all clean module

# Default target: Build the Rust project and the kernel module
all: module

# Build the Rust project
$(RUST_DIR)/target/release/librust_hello.a: $(RUST_DIR)/Cargo.toml $(RUST_DIR)/src/lib.rs
	cd $(RUST_DIR) && cargo build --release

# Build the kernel module using the kernel build system
module: $(RUST_DIR)/target/release/librust_hello.a $(BUILD_DIR)/Makefile
	$(MAKE) -C $(KERNEL_SRC_PATH) M=$(PWD)/$(BUILD_DIR) modules

# Clean the build directory
clean:
	rm -rf $(BUILD_DIR) $(RUST_DIR)/target

# Set up the build directory structure for the kernel build system
$(BUILD_DIR)/Makefile: $(BUILD_DIR)/Kbuild
	mkdir -p $(BUILD_DIR)
	ln -sf $(PWD)/Kbuild $(BUILD_DIR)/Kbuild

# Create a Kbuild file to instruct the kernel build system
$(BUILD_DIR)/Kbuild: 
	echo "obj-m += $(MODULE_NAME).o" > $(BUILD_DIR)/Kbuild
	echo "$(MODULE_NAME)-objs := $(RUST_DIR)/target/release/librust_hello.a" >> $(BUILD_DIR)/Kbuild

# Ensure the build directory is set up before building the module
$(RUST_DIR)/target/release/librust_hello.a: $(BUILD_DIR)/Makefile
