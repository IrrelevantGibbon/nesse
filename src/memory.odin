package nesse

/*
*/
Memory :: struct {
	memory: [0xFFFF]u8,
}


Word :: u16
Byte :: u8


initMemory :: proc() -> Memory {
	return Memory{}
}

readMemoryByte :: proc(memory: ^Memory, addr: Word) -> Byte {
	return memory.memory[addr]
}

readMemoryWord :: proc(memory: ^Memory, address: Word) -> Word {
	return Le2Be(readMemoryByte(memory, address), readMemoryByte(memory, address + 1))
}

writeMemoryByte :: proc(memory: ^Memory, address: Word, value: Byte) {
	memory.memory[address] = value
}
