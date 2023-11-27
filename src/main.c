#include <SDL2/SDL.h>
#include <stdbool.h>
#include <stdio.h>
#include "utils.h"


int main(int argc, char* argv[]) {
    // Initialize SDL
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        printf("SDL could not initialize! SDL_Error: %s\n", SDL_GetError());
        return 1;
    }

    LOG(LOG_INFO, "This is an info message.");
    LOG(LOG_WARNING, "This is a warning message.");
    LOG(LOG_ERROR, "This is an error message.");

    // Create window
    SDL_Window* window = SDL_CreateWindow(
        "Hello World",                  // window title
        SDL_WINDOWPOS_UNDEFINED,        // initial x position
        SDL_WINDOWPOS_UNDEFINED,        // initial y position
        640,                            // width, in pixels
        480,                            // height, in pixels
        SDL_WINDOW_SHOWN                // flags - SDL_WINDOW_SHOWN, etc.
    );

    if (window == NULL) {
        printf("Window could not be created! SDL_Error: %s\n", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    // Main loop flag
    bool quit = false;

    // Event handler
    SDL_Event e;

    // While application is running
    while (!quit) {
        // Handle events on queue
        while (SDL_PollEvent(&e) != 0) {
            // User requests quit
            if (e.type == SDL_QUIT) {
                quit = true;
            }
        }
    }

    // Destroy window
    SDL_DestroyWindow(window);

    // Quit SDL subsystems
    SDL_Quit();

    return 0;
}
