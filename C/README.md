A couple of notes about the C templates:  

Beside the usual Template that uses gcc/clang/emcc, I've also included  
one that uses the zig build system. This is mostly due to its cross-compilation  
capabilities. This version, like Zig, builds raylib from scratch, so there are  
no binaries included and raylib has to be cloned with submodules and built.

In EXTRAS I've also included an old implementation of Vectors from C++  
aka resizable arrays.