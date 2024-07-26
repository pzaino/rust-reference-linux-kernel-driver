# RKM (Rust Kernel Module)

This is just my own Rust Kernel Module template.
I use it to create my own modules and drivers for the Linux Kernel.

Should work on most distros, but I'm using mostly OpenSUSE Tumbleweed these days.

**Please Note**: Writing kernel modules and drivers in Rust may or may not be
supported by your Distro or Kernel release. Please check the documentation
and the kernel version you are using before messaging me or opening an issue.
Also, writing kernel modules and drivers in Rust is not the same as writing
user-space applications. You need to be aware of the risks and the consequences
of writing kernel code and you must know what you're doing.

## How to use

1. Clone this repository
2. Change the name of the module in the `Cargo.toml` file
3. Change the name of the module in the `src/lib.rs` file
4. Update module_metadata in `src/module_metadata.rs`
5. Add your driver code in the `src/driver.rs` file
6. If needed update the `src/module.c` file
7. Run `make` to build the module

## How to load the module

1. Run `sudo insmod target/debug/lib<module_name>.ko`
2. Check the kernel logs with `dmesg` to see if the module was loaded correctly
