package nesse_test

import nesse "../src"
import "core:testing"

bite :: proc() -> int {
	return 1
}

@(test)
instructions_BRK :: proc(t: ^testing.T) {
	testing.expect(t, bite() == 1)
}
