#include "cpu.h"
#include "utils.h"
#include <stdlib.h>
#include <string.h>


Cpu* initCpu()
{
    Cpu* cpu = (Cpu *)safeMalloc(sizeof(Cpu));
    resetCpu(cpu);
    return cpu;
}

void resetCpu(Cpu* cpu)
{
    cpu->interupts = initInterupts();
    cpu->memory = initMemory();
    cpu->registers = initRegisters();
}

void cleanCpu(Cpu* cpu)
{
    free(cpu);
}

Interups initInterupts()
{
    return (Interups) { false, false, false };
}

Memory initMemory()
{
    Memory mem;
    memset(mem.memory, 0, sizeof(mem.memory));
    return mem;
}

Registers initRegisters()
{
    return (Registers) {0, 0, 0, 0, 0, 0};
}





