extern crate alloc;

use crate::logging::printk;
use alloc::vec::Vec;

pub fn init() {
    // Example use of Vec in kernel module
    let mut data: Vec<u32> = Vec::new();
    data.push(1);
    data.push(2);
    data.push(3);

    for val in &data {
        printk!("Value: {}\n", val);
    }

    printk!("Driver initialized with Vec.\n");
}

pub fn cleanup() {
    printk!("Driver cleaned up.\n");
}
