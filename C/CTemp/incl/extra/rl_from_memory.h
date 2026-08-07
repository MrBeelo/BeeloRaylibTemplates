/**********************************************************************************************
*
*   rl_from_memory.h - A few memory loading related helper functions for raylib
*
*   MIT License
*
*   Copyright (c) 2026 MrBeelo
*
*   Permission is hereby granted, free of charge, to any person obtaining a copy
*   of this software and associated documentation files (the "Software"), to deal
*   in the Software without restriction, including without limitation the rights
*   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*   copies of the Software, and to permit persons to whom the Software is
*   furnished to do so, subject to the following conditions:
*
*   The above copyright notice and this permission notice shall be included in all
*   copies or substantial portions of the Software.
*
*   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*   SOFTWARE.
*
**********************************************************************************************/

#include "raylib.h"
#include <stdio.h>
#include <stdlib.h>

// Loads a sound from memory by loading a wave from memory first,
// then importing a sound from it and deleting it.
Sound LoadSoundFromMemory(const char* extension, const unsigned char *data) {
    Wave wave = LoadWaveFromMemory(extension, data, sizeof(data));
    Sound sound = LoadSoundFromWave(wave);
    UnloadWave(wave);
    return sound;
}

// Same as LoadSoundFromMemory, but with Texture and Image.
Texture LoadTextureFromMemory(const char* extension, const unsigned char *data) {
    Image image = LoadImageFromMemory(extension, data, sizeof(data));
    Texture texture = LoadTextureFromImage(image);
    UnloadImage(image);
    return texture;
}

// Creates a temporary directory at temp_dir, writes a model in it (embedded in the program),
// reads it, and destroys the file and directory as needed.
Model LoadModelFromMemory(const char* extension, const unsigned char *data, const char* temp_dir) {
    bool temp_dir_exists = DirectoryExists(temp_dir);
    if (!temp_dir_exists) MakeDirectory(temp_dir);

    const char* file_dir = TextFormat("%s/temp%s", temp_dir, extension);

    printf("GAME: Loading temp file at %s\n", file_dir);
    if (FileExists(file_dir)) {
        printf("GAME: File at %s already exists, continuing would overwrite and delete it!\n", file_dir);
        abort();
    }

    SaveFileData(file_dir, data, sizeof(data));
    Model new_model = LoadModel(file_dir);

    FileRemove(file_dir);
    if (!temp_dir_exists) FileRemove(temp_dir);

    return new_model;
}