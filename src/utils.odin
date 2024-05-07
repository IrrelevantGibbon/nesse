package nesse

BeToLe :: proc(hb: Byte, lb: Byte) -> Word {
	return (Word(lb) << 8) | Word(hb)
}

Le2Be :: proc(hb: Byte, lb: Byte) -> Word {
	return (Word(lb) << 8) | Word(hb)
}
