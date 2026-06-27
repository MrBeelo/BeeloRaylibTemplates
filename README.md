Hello :)

This is a collection of templates that I use for all of my games.

All of them include a simple makefile that you can use to build your game.

All templates non-Odin uses git submodules, so make sure to clone those as well.


Some notes about each one:

- CTemp also works for C++ if set so in the makefile/build command. I also added a vector
struct for C in TempHelpers as I've found it to be useful when making my game. Since it uses the
zig build system for easier cross-compilation, you will need to modify build.zig and build.zig.zon to
properly change the name of your game.

- ZigTemp uses the actual C version of raylib along with @cImport.
An outdated version of ZigTemp that uses the raylib-zig bindings can be found in OLD. 
You will also need to modify build.zig and build.zig.zon to properly change the name of
your game (along with the fingerprint).

- OdinTemp has been really dumbed down, and I haven't added support for cross-compilation
in the makefile yet. It also uses vendor:raylib, which should come with your odin installation,
so it's pretty simple. A version that can also compile to the web using emscripten can be found at
OdinWebTemp.

That's about it!

Current version: 1.0.6
