package nesse

/*
*/
Memory :: struct {
	memory: [0xFFFF]u8,
}


initMemory :: proc() -> Memory {
	return Memory{}
}
