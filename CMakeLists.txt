cmake_minimum_required(VERSION 3.2.7)
include(ExternalProject)
project(Nesse VERSION 1.0.0 DESCRIPTION "NES Emulator" LANGUAGES C)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-unused-command-line-argument")

if (POLICY CMP0025)
    cmake_policy(SET CMP0025 NEW)
endif ()

if(POLICY CMP0135)
    cmake_policy(SET CMP0135 NEW)
endif()

set(H_FILE "*.h")
set(C_FILE "*.c")

set(SRC_DIR "${PROJECT_SOURCE_DIR}/src")
set(BUILD "${PROJECT_SOURCE_DIR}/build")

set(SDL_BUILD "${BUILD}/SDL2")

if (NOT EXISTS ${BUILD})
    message(STATUS "Build directory not found. Creating...")
    file(MAKE_DIRECTORY ${BUILD})
    message(STATUS "Build directory created")
endif()


if (NOT EXISTS ${SDL_BUILD})
    message(STATUS "SDL2 Build directory not found. Creating...")
    file(MAKE_DIRECTORY ${SDL_BUILD})
    message(STATUS "SDL2 Build directory created")
endif()


ExternalProject_Add(
  sdl2_local
  GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
  GIT_TAG release-2.0.14
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${SDL_BUILD} -DCMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR} -DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}
)


include_directories(${SRC_DIR}, "${SDL_BUILD}/include/SDL2")

file(GLOB all_SRCS
        "${SDL_BUILD}/include/SDL2/${H_FILE}"
        "${SRC_DIR}/${C_FILE}"
        "${SRC_DIR}/${H_FILE}"
    )

add_executable(Nesse ${all_SRCS})
add_dependencies(Nesse sdl2_local)
target_link_libraries(Nesse ${SDL_BUILD}/lib/libSDL2.so)
