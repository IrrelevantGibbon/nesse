package nesse_test

import nesse "../src"
import "core:fmt"
import "core:testing"


@(test)
instructions_BRK :: proc(t: ^testing.T) {
	nes := nesse.initNesse()
	defer free(nes)
	testing.expect(t, nes.cpu.registers.st == 0x0)
	nesse.BRK(&nes.cpu)
	testing.expect(t, nes.cpu.registers.st == 0x10)
}

@(test)
instructions_LDA :: proc(t: ^testing.T) {
	nes := nesse.initNesse()
	defer free(nes)
	testing.expect(t, nes.cpu.registers.pc == 0x0)
	nesse.LDA(&nes.cpu, &nes.memory)

	/* memory[pc] == 0  */
	testing.expect(t, nes.cpu.registers.pc == 0x1)
	testing.expect(t, nes.cpu.registers.acc == 0x0)
	testing.expect(t, nes.cpu.registers.st == 0x2)

	nes.memory.memory[nes.cpu.registers.pc] = 0xFF
	nesse.LDA(&nes.cpu, &nes.memory)
	/* memory[pc] == 7 bit == 1 */
	testing.expect(t, nes.cpu.registers.pc == 0x2)
	testing.expect(t, nes.cpu.registers.acc == 0xFF)
	testing.expect(t, nes.cpu.registers.st == 0x80)
}


@(test)
instructions_TAX :: proc(t: ^testing.T) {
	nes := nesse.initNesse()
	defer free(nes)
	testing.expect(t, nes.cpu.registers.acc == 0x0)
	nesse.TAX(&nes.cpu)
	/* acc = 0 */
	testing.expect(t, nes.cpu.registers.x == 0x0)
	testing.expect(t, nes.cpu.registers.st == 0x2)

	/* acc == 7 bit == 1 */
	nes.cpu.registers.acc = 0xFF
	nesse.TAX(&nes.cpu)
	testing.expect(t, nes.cpu.registers.x == 0xFF)
	testing.expect(t, nes.cpu.registers.st == 0x80)
}
