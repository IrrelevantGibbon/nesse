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
	st:  StatusRegister,
	acc: u8,
	x:   u8,
	y:   u8,
}

StatusRegister :: struct {
	negative:  bool,
	overflow:  bool,
	reserved:  bool,
	break_:    bool,
	decimal:   bool,
	interrupt: bool,
	zero:      bool,
	carry:     bool,
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


initCpu :: proc() -> Cpu {
	return(
		Cpu {
			Registers {
				0x8000,
				0xFD,
				StatusRegister{false, false, true, true, false, true, false, false},
				0,
				0,
				0,
			},
			Interupts{false, false, false},
		} \
	)
}

emulateCycle :: proc(cpu: ^Cpu, memory: ^Memory) {
	execute(cpu, memory, fetch(cpu, memory))
}

fetch :: proc(cpu: ^Cpu, memory: ^Memory) -> Opcode {
	cpu := cpu
	opcode := memory.memory[cpu.registers.pc]
	cpu.registers.pc += 1
	return Opcodes[opcode]
}

execute :: proc(cpu: ^Cpu, memory: ^Memory, opcode: Opcode) {
	// Opcodes.func(cpu, memory, opcode.addrMode)
}

/*
    Status register functions
*/


/*
    Set Break flag
*/

setC :: proc(st: ^StatusRegister, condition: bool = false) {
	st.carry = condition
}

setD :: proc(st: ^StatusRegister, condition: bool = false) {
	st.decimal = condition
}

setI :: proc(st: ^StatusRegister, condition: bool = false) {
	st.interrupt = condition
}


setB :: proc(st: ^StatusRegister, condition: bool = false) {
	st.break_ = condition
}

setZ :: proc(st: ^StatusRegister, condition: bool = false) {
	st.zero = condition
}

setN :: proc(st: ^StatusRegister, condition: bool = false) {
	st.negative = condition
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
