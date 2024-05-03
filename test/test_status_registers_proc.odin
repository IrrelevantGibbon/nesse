package nesse_test

import nesse "../src"
import "core:testing"


@(test)
setZ :: proc(t: ^testing.T) {
	register: nesse.StatusRegister = 0
	nesse.setZ(&register, true)
	testing.expect(t, register == 0x2)
	nesse.setZ(&register, false)
	testing.expect(t, register == 0x0)
}

@(test)
setN :: proc(t: ^testing.T) {
	register: nesse.StatusRegister = 0
	nesse.setN(&register, true)
	testing.expect(t, register == 0x80)
	nesse.setN(&register, false)
	testing.expect(t, register == 0x0)
}

@(test)
setB :: proc(t: ^testing.T) {
	register: nesse.StatusRegister = 0
	nesse.setB(&register, true)
	testing.expect(t, register == 0x10)
	nesse.setB(&register, false)
	testing.expect(t, register == 0x0)
}
