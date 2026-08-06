#include "raylib.h"

#define RAYGUI_IMPLEMENTATION
#include "raygui.h"

Sound sound;

int main() {
    InitWindow(400, 200, "raygui - controls test suite");
    SetTargetFPS(60);
    InitAudioDevice();

    bool showMessageBox = false;
    sound = LoadSound("res/sound.mp3");

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(GetColor(GuiGetStyle(DEFAULT, BACKGROUND_COLOR)));

        if (GuiButton((Rectangle){ 24, 24, 120, 30 }, "#191#Show Message")) { 
            showMessageBox = true;
            PlaySound(sound);
        }

        if (showMessageBox) {
            int btnActive = -1;
            GuiMessageBox((Rectangle){ 85, 70, 250, 100 }, "#191#Message Box", "Hi! This is a message!", "Nice;Cool", &btnActive);

            if (btnActive >= 0) showMessageBox = false;
        }

        EndDrawing();
    }

    UnloadSound(sound);
    CloseWindow();
    return 0;
}