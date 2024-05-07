package nesse

Nesse :: struct {
	cpu:    Cpu,
	memory: Memory,
}

initNesse :: proc() -> ^Nesse {
	nesse := new(Nesse)
	nesse^ = Nesse{initCpu(), initMemory()}
	return nesse
}

interpret :: proc() {
	nesse := initNesse()
	emulateCycle(&nesse.cpu, &nesse.memory)
}
