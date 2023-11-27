#pragma once
#include <stdint.h>
#include <stdbool.h>

// todo: Change it
#define EMULATE_CYCLE 8

typedef struct
{
    u_int8_t memory[0xFFF]; // 65535
    u_int16_t pc; // program counter
    u_int8_t sp; // stack pointer
    u_int8_t sr; // processor status register
    u_int8_t acc; // accumulator register
    u_int8_t rx;  // x register
    u_int8_t ry; // y register

    // interupts
    // priority IRQ < NMI < RESET
    // interupt latency of 7 cycles
    bool shouldIrq;
    bool shouldNmi;
    bool shoudlReset;

} Cpu;


Cpu* initCpu();
