use std::env;
use std::fs;
use std::path::Path;

fn main() {
    // Get the kernel source path from the environment variable
    let kernel_src_path = env::var("KERNEL_SRC_PATH").expect("KERNEL_SRC_PATH is not set");

    // Create a symbolic link to the kernel crate
    let kernel_path = Path::new(&kernel_src_path).join("rust/kernel");
    let dest = Path::new("kernel_path");

    if dest.exists() {
        fs::remove_dir_all(dest).unwrap();
    }

    std::os::unix::fs::symlink(kernel_path, dest).expect("Failed to create symlink");

    // Tell Cargo to re-run this script if the environment variable changes
    println!("cargo:rerun-if-env-changed=KERNEL_SRC_PATH");
}
