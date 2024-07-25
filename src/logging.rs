#![allow(dead_code)]
#![allow(non_camel_case_types)]
#![allow(non_upper_case_globals)]

extern "C" {
    fn printk(fmt: *const u8, ...) -> i32;
}

#[macro_export]
macro_rules! printk {
    ($fmt:expr) => {
        unsafe {
            crate::logging::printk(concat!($fmt, "\0").as_ptr());
        }
    };
    ($fmt:expr, $($arg:tt)*) => {
        unsafe {
            crate::logging::printk(concat!($fmt, "\0").as_ptr(), $($arg)*);
        }
    };
}

pub fn printk(s: &str) {
    unsafe {
        printk(s.as_ptr());
    }
}
