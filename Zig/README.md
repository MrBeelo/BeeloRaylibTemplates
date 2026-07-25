A couple of notes about the Zig template:  

It builds the original raylib from scratch! Because of this, importing  
submodules is necessary (or you can just clone the raylib repo too...).  
This also enables support for cross-compilation!  

There used to be another version of this template that used the zig bindings  
of raylib instead of the original, but I haven't bothered updating it, so it  
can be found in OLD.  