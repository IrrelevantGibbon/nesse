#pragma once
#include <stdio.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#define DEBUG 1

typedef enum {
    LOG_INFO,
    LOG_WARNING,
    LOG_ERROR
} LogLevel;

const char* logLevelToString(LogLevel level)
{
    switch (level) {
        case LOG_INFO: return "INFO";
        case LOG_WARNING: return "WARNING";
        case LOG_ERROR: return "ERROR";
        default: return "UNKNOWN";
    }
}

void get_formatted_time(char *buffer)
{
    time_t rawtime;
    struct tm * timeinfo;
    time(&rawtime);
    timeinfo = localtime(&rawtime);
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", timeinfo);
}

#ifdef DEBUG
    #define LOG(TYPE, MESSAGE) do { \
        char time_buffer[80]; \
        get_formatted_time(time_buffer); \
        printf("[%s] [%s] %s:%d %s(): %s\n", logLevelToString(TYPE), time_buffer, __FILE__, __LINE__, __func__, MESSAGE); \
    } while(0)
#else
    #define LOG(TYPE, MESSAGE) do { \
        char time_buffer[80]; \
        get_formatted_time(time_buffer); \
        printf("[%s] [%s] : %s\n", logLevelToString(TYPE), time_buffer, MESSAGE); \
    } while(0)
#endif


void* safeMalloc(size_t size) {
    void* ptr = malloc(size);
    if (ptr == NULL) {
        fprintf(stderr, "Memory allocation failed for size %zu.\n", size);
        exit(EXIT_FAILURE);
    }
    return ptr;
}
