use std::env;
use std::path::PathBuf;

fn main() {
    let kernel_dir = PathBuf::from("/lib/modules/$(uname -r)/build");
    let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());
    let src_file = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap()).join("src");

    cc::Build::new()
        .file(src_file.join("module.c"))
        .include(&kernel_dir)
        .out_dir(out_dir)
        .compile("module");
}
