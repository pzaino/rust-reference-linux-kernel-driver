use kernel::prelude::*;

struct RustModule;

impl KernelModule for RustModule {
    fn init() -> Result<Self> {
        pr_info!("Rust module says hello!\n");
        Ok(RustModule)
    }
}

impl Drop for RustModule {
    fn drop(&mut self) {
        pr_info!("Rust module says goodbye!\n");
    }
}

module! {
    type: RustModule,
    name: b"rust_module",
    author: b"Rust for Linux Contributors",
    description: b"Rust hello sample",
    license: b"GPL v2",
}
