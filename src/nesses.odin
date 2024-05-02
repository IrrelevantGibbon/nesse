package nesse

Nesse :: struct {
	cpu:    Cpu,
	memory: Memory,
}

interpret :: proc() {
	nesse := new(Nesse)
	nesse^ = Nesse{initCpu(), initMemory()}

	emulateCycle(&nesse.cpu, &nesse.memory)
}
