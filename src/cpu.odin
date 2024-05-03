package nesse


StatusRegister :: u8

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
	st:  StatusRegister,
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
	LDA = 0xA9,
	TAX = 0xAA,
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
	case Opcode.LDA:
		LDA(cpu, memory)
	case Opcode.TAX:
		TAX(cpu)
	}
}

/*
    Status register functions
*/


/*
    Set Break flag
*/
setB :: proc(st: ^StatusRegister, value: bool = false) {
	switch value {
	case true:
		st^ |= 0x10
	case false:
		st^ &= 0xEF
	}
}

/*
    Set Zero flag
*/
setZ :: proc(st: ^StatusRegister, value: bool = false) {
	switch value {
	case true:
		st^ |= 0x02
	case false:
		st^ &= 0xFD
	}
}

/*
    Set Negative flag
*/
setN :: proc(st: ^StatusRegister, value: bool = false) {
	switch value {
	case true:
		st^ |= 0x80
	case false:
		st^ &= 0x7F
	}
}

/*

*/


// Instructions

/* Load / Store Operations  */
LDA :: proc(cpu: ^Cpu, memory: ^Memory) {
	/* Refacto  2 next lines */
	value := memory.memory[cpu.registers.pc]
	cpu.registers.pc += 1
	cpu.registers.acc = value
	setZ(&cpu.registers.st, cpu.registers.acc == 0x0)
	setN(&cpu.registers.st, cpu.registers.acc & 0x80 != 0x0)
}
/* Register Transfer Operations */
TAX :: proc(cpu: ^Cpu) {
	cpu.registers.x = cpu.registers.acc
	setZ(&cpu.registers.st, cpu.registers.x == 0x0)
	setN(&cpu.registers.st, cpu.registers.x & 0x80 != 0x0)
}
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
	setB(&cpu.registers.st, true)
}
