#![no_std]
#![no_main]

extern crate alloc;

use core::panic::PanicInfo;

mod logging;
mod driver;
mod allocator;
mod module_metadata;

#[no_mangle]
pub extern "C" fn init_module() -> i32 {
    logging::log_printk("Rust kernel module loaded.\n");
    driver::init();
    0 // Return 0 to indicate successful loading
}

#[no_mangle]
pub extern "C" fn cleanup_module() {
    driver::cleanup();
    logging::log_printk("Rust kernel module unloaded.\n");
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

// Remove this line if it's causing issues
// #[lang = "eh_personality"]
// extern fn eh_personality() {}
