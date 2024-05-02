package nesse

/*
    - pc  : program counter u16
    - sp  : stack pointer u8
    - st  : status u8
    - acc : accumulator u8
    - x   : general x u8
    - y   : general y u8
*/
Registers :: struct {
	pc:  u16,
	sp:  u8,
	st:  u8,
	acc: u8,
	x:   u8,
	y:   u8,
}

/*
    Priority IRQ < NMI < RESET
    Interupt latency of 7 cycles
*/
Interupts :: struct {
	irq:   b8,
	nmi:   b8,
	reset: b8,
}


Cpu :: struct {
	registers: Registers,
	interupts: Interupts,
}

Opcode :: enum {
	BRK = 0x0,
}

CPU_CYCLE :: 12 // TO DEFINE

initCpu :: proc() -> Cpu {
	return Cpu{Registers{0, 0, 0, 0, 0, 0}, Interupts{false, false, false}}
}

emulateCycle :: proc(cpu: ^Cpu, memory: ^Memory) {
	execute(cpu, memory, fetch(cpu, memory))
}

fetch :: proc(cpu: ^Cpu, memory: ^Memory) -> Opcode {
	cpu := cpu
	opcode := memory.memory[cpu.registers.pc]
	cpu.registers.pc += 1
	return Opcode(opcode)
}

execute :: proc(cpu: ^Cpu, memory: ^Memory, opcode: Opcode) {
	switch opcode {
	case Opcode.BRK:
		BRK(cpu)
	}
}


// Instructions

/* Load / Store Operations  */
LDA :: proc() {

}
/* Register Transfer Operations */
/* Stack Operations */
/* Logical Operations */

/*
    AND - Logical AND
*/
AND :: proc() {

}

/* Arithmetic Operations */

/*
    Add with Carry
*/
ADC :: proc() {

}

/* Shifts */
/* Jumps / Calls */
/* Branches */
/* Status Register Operations */
/* System Functions */
BRK :: proc(cpu: ^Cpu) {
	cpu.registers.st &= 0x11
}
