extern crate alloc;

use alloc::vec::Vec;
use alloc::format; // Import the format macro
use crate::logging::log_printk;

pub fn init() {
    // Example use of Vec in kernel module
    let mut data: Vec<u32> = Vec::new();
    data.push(1);
    data.push(2);
    data.push(3);

    for val in &data {
        log_printk(&format!("Value: {}\n", val));
    }

    log_printk("Driver initialized with Vec.\n");
}

pub fn cleanup() {
    log_printk("Driver cleaned up.\n");
}
