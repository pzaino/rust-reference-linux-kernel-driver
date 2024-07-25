use core::alloc::{GlobalAlloc, Layout};
use core::ptr::null_mut;

extern "C" {
    fn kmalloc(size: usize, flags: u32) -> *mut u8;
    fn kfree(ptr: *mut u8);
}

pub struct KernelAllocator;

unsafe impl GlobalAlloc for KernelAllocator {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        kmalloc(layout.size(), 0)
    }

    unsafe fn dealloc(&self, ptr: *mut u8, _layout: Layout) {
        kfree(ptr)
    }
}

#[global_allocator]
static ALLOCATOR: KernelAllocator = KernelAllocator;
