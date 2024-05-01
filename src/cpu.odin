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
	st:  u8,
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
