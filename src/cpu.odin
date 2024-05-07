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


AddressingMode :: enum {
	Implied,
	Immediate,
	ZeroPage,
	ZeroPageX,
	ZeroPageY,
	Absolute,
	AbsoluteX,
	AbsoluteY,
	Indirect,
	IndexedIndirect,
	IndirectIndexed,
}

Opcode :: struct {
	addrMode: AddressingMode,
	bytes:    u8,
	cycles:   u8,
	func:     union {
		proc(cpu: ^Cpu, memory: ^Memory, mode: AddressingMode),
		proc(cpu: ^Cpu),
	},
}

opcodes := map[u8]Opcode {

	/* LDA */
	0xA9 = Opcode{AddressingMode.Immediate, 2, 2, LDA},
	0xA5 = Opcode{AddressingMode.ZeroPage, 2, 3, LDA},
	0xB5 = Opcode{AddressingMode.ZeroPageX, 2, 4, LDA},
	0xAD = Opcode{AddressingMode.Absolute, 3, 4, LDA},
	0xBD = Opcode{AddressingMode.AbsoluteX, 3, 4, LDA},
	0xB9 = Opcode{AddressingMode.AbsoluteY, 3, 4, LDA},
	0xA1 = Opcode{AddressingMode.IndexedIndirect, 2, 6, LDA},
	0xB1 = Opcode{AddressingMode.IndirectIndexed, 2, 5, LDA},


	/* LDX */
	0xA2 = Opcode{AddressingMode.Immediate, 2, 2, LDX},
	0xA6 = Opcode{AddressingMode.ZeroPage, 2, 3, LDX},
	0xB6 = Opcode{AddressingMode.ZeroPageY, 2, 4, LDX},
	0xAE = Opcode{AddressingMode.Absolute, 3, 4, LDX},
	0xBE = Opcode{AddressingMode.AbsoluteY, 3, 4, LDX},

	/* LDY */
	0xA0 = Opcode{AddressingMode.Immediate, 2, 2, LDY},
	0xA4 = Opcode{AddressingMode.ZeroPage, 2, 3, LDY},
	0xB4 = Opcode{AddressingMode.ZeroPageX, 2, 4, LDY},
	0xAC = Opcode{AddressingMode.Absolute, 3, 4, LDY},
	0xBC = Opcode{AddressingMode.AbsoluteX, 3, 4, LDY},

	/* TAX */
	0xAA = Opcode{AddressingMode.Implied, 1, 2, TAX},
	/* TAY */
	0xA8 = Opcode{AddressingMode.Implied, 1, 2, TAY},
	/* TSX */
	0xBA = Opcode{AddressingMode.Implied, 1, 2, TSX},
	/* TXA */
	0x8A = Opcode{AddressingMode.Implied, 1, 2, TXA},
	/* TXS */
	0x9A = Opcode{AddressingMode.Implied, 1, 2, TXS},
	/* TYA */
	0x98 = Opcode{AddressingMode.Implied, 1, 2, TYA},
	/* SEC */
	0x38 = Opcode{AddressingMode.Implied, 1, 2, SEC},
	/* SED */
	0xF8 = Opcode{AddressingMode.Implied, 1, 2, SED},
	/* SEI */
	0x78 = Opcode{AddressingMode.Implied, 1, 2, SEI},
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
	return opcodes[opcode]
}

execute :: proc(cpu: ^Cpu, memory: ^Memory, opcode: Opcode) {
	opcode.func(cpu, memory, opcode.addrMode)
}

/*
    Status register functions
*/


/*
    Set Break flag
*/

setC :: proc(st: ^StatusRegister, value: bool = false) {
	switch value {
	case true:
		st^ |= 0x80
	case false:
		st^ &= 0x7F
	}
}

setD :: proc(st: ^StatusRegister, value: bool = false) {
	switch value {
	case true:
		st^ |= 0x08
	case false:
		st^ &= 0xF7
	}
}

setI :: proc(st: ^StatusRegister, value: bool = false) {
	switch value {
	case true:
		st^ |= 0x04
	case false:
		st^ &= 0xFB
	}
}


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
LDA :: proc(cpu: ^Cpu, memory: ^Memory, mode: AddressingMode) {
	address := getAddressingModeAddress(cpu, memory, mode)
	value := readMemoryByte(memory, address)
	cpu.registers.pc += 1
	cpu.registers.acc = value
	setZ(&cpu.registers.st, cpu.registers.acc == 0x0)
	setN(&cpu.registers.st, cpu.registers.acc & 0x80 != 0x0)
}

LDX :: proc(cpu: ^Cpu, memory: ^Memory, mode: AddressingMode) {
	address := getAddressingModeAddress(cpu, memory, mode)
	value := readMemoryByte(memory, address)
	cpu.registers.pc += 1
	cpu.registers.x = value
	setZ(&cpu.registers.st, cpu.registers.x == 0x0)
	setN(&cpu.registers.st, cpu.registers.x & 0x80 != 0x0)
}

LDY :: proc(cpu: ^Cpu, memory: ^Memory, mode: AddressingMode) {
	address := getAddressingModeAddress(cpu, memory, mode)
	value := readMemoryByte(memory, address)
	cpu.registers.pc += 1
	cpu.registers.y = value
	setZ(&cpu.registers.st, cpu.registers.y == 0x0)
	setN(&cpu.registers.st, cpu.registers.y & 0x80 != 0x0)
}

STA :: proc(cpu: ^Cpu, memory: ^Memory, mode: AddressingMode) {

}

STX :: proc(cpu: ^Cpu, memory: ^Memory, mode: AddressingMode) {

}

STY :: proc(cpu: ^Cpu, memory: ^Memory, mode: AddressingMode) {

}

/* Register Transfer Operations */
TAX :: proc(cpu: ^Cpu) {
	cpu.registers.x = cpu.registers.acc
	setZ(&cpu.registers.st, cpu.registers.x == 0x0)
	setN(&cpu.registers.st, cpu.registers.x & 0x80 != 0x0)
	cpu.registers.pc += 1
}

TAY :: proc(cpu: ^Cpu) {
	cpu.registers.y = cpu.registers.acc
	setZ(&cpu.registers.st, cpu.registers.y == 0x0)
	setN(&cpu.registers.st, cpu.registers.y & 0x80 != 0x0)
	cpu.registers.pc += 1
}

TSX :: proc(cpu: ^Cpu) {
	cpu.registers.x = cpu.registers.sp
	setZ(&cpu.registers.st, cpu.registers.x == 0x0)
	setN(&cpu.registers.st, cpu.registers.x & 0x80 != 0x0)
	cpu.registers.pc += 1
}

TXA :: proc(cpu: ^Cpu) {
	cpu.registers.acc = cpu.registers.x
	setZ(&cpu.registers.st, cpu.registers.acc == 0x0)
	setN(&cpu.registers.st, cpu.registers.acc & 0x80 != 0x0)
	cpu.registers.pc += 1
}

TXS :: proc(cpu: ^Cpu) {
	cpu.registers.sp = cpu.registers.x
	cpu.registers.pc += 1
}

TYA :: proc(cpu: ^Cpu) {
	cpu.registers.acc = cpu.registers.y
	setZ(&cpu.registers.st, cpu.registers.acc == 0x0)
	setN(&cpu.registers.st, cpu.registers.acc & 0x80 != 0x0)
	cpu.registers.pc += 1
}
/* Stack Operations */
/* Logical Operations */

// LSR :: proc(cpu: ^Cpu, memory)

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

SEC :: proc(cpu: ^Cpu) {
	setC(&cpu.registers.st, true)
	cpu.registers.pc += 1
}

SED :: proc(cpu: ^Cpu) {
	setD(&cpu.registers.st, true)
	cpu.registers.pc += 1
}

SEI :: proc(cpu: ^Cpu) {
	setI(&cpu.registers.st, true)
	cpu.registers.pc += 1
}

/* System Functions */
BRK :: proc(cpu: ^Cpu) {
	setB(&cpu.registers.st, true)
	cpu.registers.pc += 1
}


getAddressingModeAddress :: proc(cpu: ^Cpu, memory: ^Memory, mode: AddressingMode) -> Word {
	switch mode {
	case AddressingMode.Immediate:
		return cpu.registers.pc
	case AddressingMode.ZeroPage:
		return Word(readMemoryByte(memory, cpu.registers.pc))
	case AddressingMode.Absolute:
		return readMemoryWord(memory, cpu.registers.pc)
	case AddressingMode.ZeroPageX:
		{
			location := Word(readMemoryByte(memory, cpu.registers.pc)) + Word(cpu.registers.x)
			if location > 0xFF {
				// Page Crossed Cycle + 1
			}
			return location
		}
	case AddressingMode.ZeroPageY:
		{
			location := Word(readMemoryByte(memory, cpu.registers.pc)) + Word(cpu.registers.y)
			if location > 0xFF {
				// Page Crossed Cycle + 1
			}
			return location
		}
	case AddressingMode.AbsoluteX:
		{
			return readMemoryWord(memory, cpu.registers.pc) + Word(cpu.registers.x)
		}
	case AddressingMode.AbsoluteY:
		{
			return readMemoryWord(memory, cpu.registers.pc) + Word(cpu.registers.y)
		}
	/*
	        3 bytes -> Opcode Byte1 Byte2
			example : JMP ($FFFC)
	    */
	case AddressingMode.Indirect:
		{
			base :=
				Word(readMemoryByte(memory, cpu.registers.pc + 1)) << 8 |
				Word(readMemoryByte(memory, cpu.registers.pc))
			location :=
				Word(readMemoryByte(memory, base + 1)) << 8 | Word(readMemoryByte(memory, base))
			location = location + 1 if location & 0xFF == 0xFF else location
			return location
		}
	/*
	       2 bytes -> Opcode Byte1, X
		   example : LDA ($40,X)
					*/
	case AddressingMode.IndexedIndirect:
		{
			location := Word(readMemoryByte(memory, cpu.registers.pc)) + Word(cpu.registers.x)
			location =
				Word(readMemoryByte(memory, location)) >> 8 |
				Word(readMemoryByte(memory, location + 1))
			return location
		}
	/*
		2 bytes -> Opcode Byte1, y
		example : LDA ($40,X)
	 */
	case AddressingMode.IndirectIndexed:
		{
			base := Word(readMemoryByte(memory, cpu.registers.pc))
			location :=
				Word(readMemoryByte(memory, base + 1)) >> 8 | Word(readMemoryByte(memory, base))
			location = location + Word(cpu.registers.y)
			return location
		}
	case AddressingMode.Implied:
		{}
	}
	return 0
}
