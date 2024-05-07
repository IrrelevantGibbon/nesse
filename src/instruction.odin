package nesse


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
	address := getAddressingModeAddress(cpu, memory, mode)
	writeMemoryByte(memory, address, cpu.registers.acc)
}

STX :: proc(cpu: ^Cpu, memory: ^Memory, mode: AddressingMode) {
	address := getAddressingModeAddress(cpu, memory, mode)
	writeMemoryByte(memory, address, cpu.registers.x)
}

STY :: proc(cpu: ^Cpu, memory: ^Memory, mode: AddressingMode) {
	address := getAddressingModeAddress(cpu, memory, mode)
	writeMemoryByte(memory, address, cpu.registers.y)
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
AND :: proc(cpu: ^Cpu, memory: ^Memory, mode: AddressingMode) {
	address := getAddressingModeAddress(cpu, memory, mode)
	value := readMemoryByte(memory, address)
	cpu.registers.acc &= value
	setZ(&cpu.registers.st, cpu.registers.acc == 0x0)
	setN(&cpu.registers.st, cpu.registers.acc & 0x80 != 0x0)
}

/* Arithmetic Operations */

ADC :: proc(cpu: ^Cpu, memory: ^Memory, mode: AddressingMode) {
	address := getAddressingModeAddress(cpu, memory, mode)
	value := readMemoryByte(memory, address)
	old_acc := cpu.registers.acc
	cpu.registers.acc = cpu.registers.acc + value + u8(cpu.registers.st.carry)
	is_overflow := old_acc > cpu.registers.acc
	setV(&cpu.registers.st, is_overflow)
	setC(&cpu.registers.st, getV(getST(cpu)))
	setZ(&cpu.registers.st, cpu.registers.acc == 0x0)
	setN(&cpu.registers.st, cpu.registers.acc & 0x80 != 0x0)
}

ASL :: proc(cpu: ^Cpu, memory: ^Memory, mode: AddressingMode) {
	if mode == AddressingMode.Accumulator {
		setC(&cpu.registers.st, bool(cpu.registers.acc & 0x80 >> 7))
		cpu.registers.acc <<= 1
		setZ(&cpu.registers.st, cpu.registers.acc == 0x0)
		setN(&cpu.registers.st, cpu.registers.acc & 0x80 != 0x0)
	} else {
		address := getAddressingModeAddress(cpu, memory, mode)
		value := readMemoryByte(memory, address)
		setC(&cpu.registers.st, bool(value & 0x80 >> 7))
		value <<= 1
		writeMemoryByte(memory, address, value)
		setZ(&cpu.registers.st, value == 0x0)
		setN(&cpu.registers.st, value & 0x80 != 0x0)
	}
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
