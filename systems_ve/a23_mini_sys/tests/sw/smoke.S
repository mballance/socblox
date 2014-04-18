
.text
.code 32

.global _start
.func _start


_start:

	MOV			r2, #0
	MOV			r3, #0x80000000

outer:

	MOV			r0, #0
//	MOV			r1, #4
	MOV			r1, #65536

inner:
	NOP
	NOP
	NOP
	NOP
	NOP
	ADD			r0, r0, #1
	CMP			r0, r1
	BNE			inner


	ADD			r2, r2, #1
	STR			r2, [r3]

	B			outer


