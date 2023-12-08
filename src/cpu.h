#pragma once
#include <stdint.h>
#include <stdbool.h>

// todo: Change it
#define EMULATE_CYCLE 8

typedef struct {
    uint8_t memory[0xFFFF]; // 65535
} Memory;

typedef struct
{
    // priority IRQ < NMI < RESET
    // interupt latency of 7 cycles
    bool irq;
    bool nmi;
    bool reset;
} Interups;

typedef struct
{
    uint16_t pc; // program counter
    uint8_t sp; // stack pointer
    uint8_t sr; // processor status register
    uint8_t acc; // accumulator register
    uint8_t rx;  // x register
    uint8_t ry; // y register
} Registers;

typedef struct
{
    Registers registers;
    Memory memory;
    Interups interupts;

} Cpu;

Cpu* initCpu();
void resetCpu(Cpu *cpu);
void cleanCpu(Cpu* cpu);

void fetch();
void decode();
void execute();

Interups initInterupts();
Registers initRegisters();
Memory initMemory();
