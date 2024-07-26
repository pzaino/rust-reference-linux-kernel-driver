ifneq ($(KERNELRELEASE),)
obj-m := rust_kernel_module.o
rust_kernel_module-objs := module.o module_metadata.o target/release/librust_kernel_module.a

else
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
#KDIR  := /usr/src/linux-$(LKER_BASE)-obj
#KINC1 := /usr/src/linux-$(LKER_BASE)-obj/$(LKARCH)/default/include/linux
#KINC2 := /usr/src/linux-$(LKER_BASE)-obj/include/
KINC3  := /usr/src/linux-$(LKER_BASE)-obj/$(LKARCH)/default/include/
KARCH1 := /usr/src/linux-$(LKER_BASE)-obj/$(LKARCH_R)/default/arch/$(LKARCH)/include/
KARCH2 := /usr/src/linux-$(LKER_BASE)-obj/$(LKARCH_R)/default/arch/$(LKARCH)/include/generated/
endif

PWD   := $(shell pwd)

all: rustlib kernel_module

rustlib:
	cargo build --release

module.o: src/module.c
	$(CC) $(CFLAGS) -I$(KINC1) -I$(KINC2) -I$(KINC3) -I$(KARCH0) -I$(KARCH1) -I$(KARCH2) -c -o $@ $<

module_metadata.o: src/module_metadata.c
	$(CC) $(CFLAGS) -c -o $@ $<

kernel_module: module.o module_metadata.o
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	cargo clean
	rm -f module.o module_metadata.o
	$(MAKE) -C $(KDIR) M=$(PWD) clean

endif
