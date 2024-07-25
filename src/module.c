#include <linux/module.h>
#include <linux/kernel.h>

extern int init_module(void);
extern void cleanup_module(void);

static int __init rust_init(void) {
    return init_module();
}

static void __exit rust_exit(void) {
    cleanup_module();
}

module_init(rust_init);
module_exit(rust_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Your Name <your.email@example.com>");
MODULE_DESCRIPTION("A simple Rust kernel module");