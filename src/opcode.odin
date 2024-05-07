package nesse

Opcode :: struct {
	addrMode: AddressingMode,
	bytes:    u8,
	cycles:   u8,
	func:     union {
		proc(cpu: ^Cpu, memory: ^Memory, mode: AddressingMode),
		proc(cpu: ^Cpu),
	},
}


Opcodes := map[u8]Opcode {

	/* ADC */
	0x69 = Opcode{AddressingMode.Immediate, 2, 2, ADC},
	0x65 = Opcode{AddressingMode.ZeroPage, 2, 3, ADC},
	0x75 = Opcode{AddressingMode.ZeroPageX, 2, 4, ADC},
	0x6D = Opcode{AddressingMode.Absolute, 3, 4, ADC},
	0x7D = Opcode{AddressingMode.AbsoluteX, 3, 4, ADC},
	0x79 = Opcode{AddressingMode.AbsoluteY, 3, 4, ADC},
	0x61 = Opcode{AddressingMode.IndexedIndirect, 2, 6, ADC},
	0x71 = Opcode{AddressingMode.IndirectIndexed, 2, 5, ADC},

	/* AND */
	0x29 = Opcode{AddressingMode.Immediate, 2, 2, AND},
	0x25 = Opcode{AddressingMode.ZeroPage, 2, 3, AND},
	0x35 = Opcode{AddressingMode.ZeroPageX, 2, 4, AND},
	0x2D = Opcode{AddressingMode.Absolute, 3, 4, AND},
	0x3D = Opcode{AddressingMode.AbsoluteX, 3, 4, AND},
	0x39 = Opcode{AddressingMode.AbsoluteY, 3, 4, AND},
	0x21 = Opcode{AddressingMode.IndexedIndirect, 2, 6, AND},
	0x31 = Opcode{AddressingMode.IndirectIndexed, 2, 5, AND},

	/* ASL */
	0x0A = Opcode{AddressingMode.Accumulator, 1, 2, ASL},
	0x06 = Opcode{AddressingMode.ZeroPage, 2, 5, ASL},
	0x16 = Opcode{AddressingMode.ZeroPageX, 2, 6, ASL},
	0x0E = Opcode{AddressingMode.Absolute, 3, 6, ASL},
	0x1E = Opcode{AddressingMode.AbsoluteX, 3, 7, ASL},

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
	/* STA */
	0x85 = Opcode{AddressingMode.ZeroPage, 2, 3, STA},
	0x95 = Opcode{AddressingMode.ZeroPageX, 2, 4, STA},
	0x8D = Opcode{AddressingMode.Absolute, 2, 4, STA},
	0x9D = Opcode{AddressingMode.AbsoluteX, 2, 5, STA},
	0x99 = Opcode{AddressingMode.AbsoluteY, 2, 5, STA},
	0x81 = Opcode{AddressingMode.IndexedIndirect, 2, 6, STA},
	0x91 = Opcode{AddressingMode.IndirectIndexed, 2, 6, STA},
	/* STX */
	0x86 = Opcode{AddressingMode.ZeroPage, 2, 3, STX},
	0x96 = Opcode{AddressingMode.ZeroPageY, 2, 4, STX},
	0x8E = Opcode{AddressingMode.Absolute, 3, 4, STX},
	/* STY */
	0x84 = Opcode{AddressingMode.ZeroPage, 2, 3, STY},
	0x94 = Opcode{AddressingMode.ZeroPageX, 2, 4, STY},
	0x8c = Opcode{AddressingMode.Absolute, 3, 4, STY},
}
