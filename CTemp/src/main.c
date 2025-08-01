#include "headers/raylib.h"
#include "headers/resource_dir.h"

int main(void)
{
    InitWindow(800, 450, "CTemp");
    SearchAndSetResourceDir("res");

    Texture2D blob = LoadTexture("blob.png");
    
    while (!WindowShouldClose())
    {
        BeginDrawing();
            ClearBackground(RAYWHITE);
            DrawText("Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY);
            DrawTexture(blob, 400 - (blob.width / 2), 150, WHITE);
				DrawText(TextFormat("FPS: %.1d", GetFPS()), 10, 10, 32, LIGHTGRAY);
        EndDrawing();
    }

    CloseWindow();

    return 0;
}
