#![no_std]
#![no_main]

extern crate alloc;

use alloc::vec::Vec;
use core::panic::PanicInfo;

mod allocator;
mod driver;
mod logging;

#[no_mangle]
pub extern "C" fn init_module() -> i32 {
    logging::printk("Rust kernel module loaded.\n");
    driver::init();
    0 // Return 0 to indicate successful loading
}

#[no_mangle]
pub extern "C" fn cleanup_module() {
    driver::cleanup();
    logging::printk("Rust kernel module unloaded.\n");
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[lang = "eh_personality"]
extern "C" fn eh_personality() {}
