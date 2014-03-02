/*
 * a23_disasm_tracer.cpp
 *
 *  Created on: Mar 2, 2014
 *      Author: ballance
 */

#include "a23_disasm_tracer.h"
#include <string.h>

typedef enum {
	REGOP,
	MULT,
	SWAP,
	TRANS,
	MTRANS,
	BRANCH,
	CODTRANS,
	COREGOP,
	CORTRANS,
	SWI,
	UNKNOWN
} op_type_t;

typedef enum {
	AND,
	EOR,
	SUB,
	RSB,
	ADD,
	ADC,
	SBC,
	RSC,
	TST,
	TEQ,
	CMP,
	CMN,
	ORR,
	MOV,
	BIC,
	MVN
} opcode_t;

a23_disasm_tracer::a23_disasm_tracer(FILE *fp) : port(this) {
	m_fp = fp;

	for (int i=0; i<sizeof(m_regs)/sizeof(uint32_t); i++) {
		m_regs[i] = 0;
	}
}

a23_disasm_tracer::~a23_disasm_tracer() {
	// TODO Auto-generated destructor stub
}

void a23_disasm_tracer::mem_access(
		uint32_t			addr,
		bool				is_write,
		uint32_t			data)
{
	fprintf(m_fp, "MEM_ACCESS: %s 0x%08x 0x%08x\n",
			(is_write)?"WRITE":"READ", addr, data);
}

void a23_disasm_tracer::execute(
		uint32_t			addr,
		uint32_t			op
		)
{
	const char *op_s = 0;
	char op_args[1024];
	char tmp[512];
	op_type_t op_type = UNKNOWN;
	uint32_t opcode = ((op >> 21) & 0xF);
	uint32_t condition = ((op >> 28) & 0xF);
	uint32_t s_bit = ((op >> 20) & 0x1);
	uint32_t reg_n = ((op >> 16) & 0xF);
	uint32_t reg_d = ((op >> 12) & 0xF);
	uint32_t reg_m = ((op >> 0) & 0xF);
	uint32_t reg_s = ((op >> 8) & 0xF);
	uint32_t shift_imm = ((op >> 7) & 0x1F);
	uint32_t offset12 = ((op >> 0) & 0xFFF);
	uint32_t offset8 = (((op >> 8) & 0xF) | (op & 0xF));
	uint32_t imm8 = (op & 0xFF);
	uint32_t imm32 = 0;

	switch ((op >> 8) & 0xF) {
		case 0: imm32 = imm8; break;
		case 1: imm32 = (((imm8 & 0x03) << 30) | ((imm8 >> 2) & 0x3F)); break;
		case 2: imm32 = (((imm8 & 0x0F) << 28) | ((imm8 >> 4) & 0x0F)); break;
		case 3: imm32 = (((imm8 & 0x3F) << 26) | ((imm8 >> 6) & 0x03)); break;
		case 4: imm32 = (((imm8 & 0xFF) << 24)); break;
		case 5: imm32 = (imm8 << 22); break;
		case 6: imm32 = (imm8 << 20); break;
		case 7: imm32 = (imm8 << 18); break;
		case 8: imm32 = (imm8 << 16); break;
		case 9: imm32 = (imm8 << 14); break;
		case 10: imm32 = (imm8 << 12); break;
		case 11: imm32 = (imm8 << 10); break;
		case 12: imm32 = (imm8 << 8); break;
		case 13: imm32 = (imm8 << 6); break;
		case 14: imm32 = (imm8 << 4); break;
		case 15: imm32 = (imm8 << 2); break;
	}

	if (
			((op >> 23) & 0x1F) == 2 &&
			((op >> 20) & 0x3) == 0 &&
			((op >> 4) & 0xFF) == 9) {
		op_type = SWAP;
	} else if (
			((op >> 22) & 0x3F) == 0 &&
			((op >> 4) & 0xF) == 9) {
		op_type = MULT;
	} else if (((op >> 26) & 0x3) == 0) {
		op_type = REGOP;
	} else if (((op >> 26) & 0x3) == 1) {
		op_type = TRANS;
	} else if (((op >> 25) & 0x7) == 4) {
		op_type = MTRANS;
	} else if (((op >> 25) & 0x7) == 5) {
		op_type = BRANCH;
	} else if (((op >> 25) & 0x7) == 6) {
		op_type = CODTRANS;
	} else if (((op >> 24) & 0xF) == 0xE &&
			((op >> 4) & 1) == 0) {
		op_type = COREGOP;
	} else if (((op >> 24) & 0xF) == 0xE &&
			((op >> 4) & 1) == 1) {
		op_type = CORTRANS;
	} else {
		op_type = SWI;
	}

	switch (op_type) {
		case REGOP:
			switch (opcode) {
				case ADC: op_s = "adc "; break;
				case ADD: op_s = "add "; break;
				case AND: op_s = "and "; break;
				case BIC: op_s = "bic "; break;
				case CMN: op_s = "cmn "; break;
				case CMP: op_s = "cmp "; break;
				case EOR: op_s = "eor "; break;
				case MOV: op_s = "mov "; break;
				case MVN: op_s = "mvn "; break;
				case ORR: op_s = "orr "; break;
				case RSB: op_s = "rsb "; break;
				case RSC: op_s = "rsc "; break;
				case SBC: op_s = "sbc "; break;
				case SUB: op_s = "sub "; break;
				case TEQ: op_s = "teq "; break;
				case TST: op_s = "tst "; break;
				default: op_s = "unk "; break;
			}
			break;
		case BRANCH:
			if (((op >> 24) & 1) == 0) {
				op_s = "b   ";
			} else {
				op_s = "bl  ";
			}
			break;

		case COREGOP:
			op_s = "cdp ";
			break;

		case CODTRANS:
			if (((op >> 20) & 1) == 1) {
				op_s = "ldc ";
			} else {
				op_s = "stc ";
			}
			break;

		case MTRANS:
			if (((op >> 20) & 1) == 1) {
				op_s = "ldm ";
			} else {
				op_s = "stm ";
			}
			break;

		case TRANS:
			switch (((op >> 21) & 2) | ((op >> 20) & 1)) {
				case 0: op_s = "str "; break;
				case 1: op_s = "ldr "; break;
				case 2: op_s = "strb"; break;
				case 3: op_s = "ldrb"; break;
			}
			break;

		case CORTRANS:
			if (((op >> 20) & 1) == 0) {
				op_s = "mcr ";
			} else {
				op_s = "mrc ";
			}
			break;

		case SWAP:
			if (((op >> 22) & 1) == 0) {
				op_s = "swp ";
			} else {
				op_s = "swpb";
			}
			break;

		case SWI:
			op_s = "swi ";
			break;
	}

	switch (op_type) {
		case REGOP:
			op_args[0] = 0;
			if (opcode != CMP && opcode != CMN && opcode != TEQ && opcode != TST) {
				strcat(op_args, warmreg(reg_d));
			}

			if (opcode != MOV && opcode != MVN) {
				if (opcode != CMP && opcode != CMN && opcode != TEQ && opcode != TST) {
					strcat(op_args, ", ");
					if (reg_d < 10 || reg_d > 12) {
						strcat(op_args, " ");
					}
				}
				strcat(op_args, warmreg(reg_n));
				strcat(op_args, ", ");
				if (reg_n < 10 || reg_n > 12) {
					strcat(op_args, " ");
				}
			} else {
				strcat(op_args, ", ");
				if (reg_d < 10 || reg_d > 12) {
					strcat(op_args, " ");
				}
			}

			if (((op >> 25) & 1) == 1) {
				if (((imm32 >> 15) & 0xFFFF) != 0) {
					sprintf(tmp, "#0x%08x", imm32);
				} else {
					sprintf(tmp, "#%d", imm32);
				}
				strcat(op_args, tmp);
			} else {
				strcat(op_args, warmreg(reg_m));
				if (((op >> 4) & 1) == 1) {
					// wshiftreg
				} else {
					// wshift
				}
			}
			fprintf(m_fp, "EXECUTE: 0x%08x: 0x%08x %s %s\n", addr, op, op_s, op_args);
			break;

		case TRANS:
			fprintf(m_fp, "EXECUTE: 0x%08x: 0x%08x %s\n", addr, op, op_s);
			break;

		default:
			fprintf(m_fp, "EXECUTE: 0x%08x: 0x%08x %s\n", addr, op, op_s);
			break;
	}

}

const char *a23_disasm_tracer::warmreg(uint32_t regnum) {
	if (regnum < 12) {
		switch (regnum) {
			case 0: return "r0";
			case 1: return "r1";
			case 2: return "r2";
			case 3: return "r3";
			case 4: return "r4";
			case 5: return "r5";
			case 6: return "r6";
			case 7: return "r7";
			case 8: return "r8";
			case 9: return "r9";
			case 10: return "r10";
			case 11: return "r11";
		}
	} else if (regnum == 12) {
		return "ip";
	} else if (regnum == 13) {
		return "sp";
	} else if (regnum == 14) {
		return "lr";
	} else if (regnum == 15) {
		return "pc";
	}
	return "unk";
}

void a23_disasm_tracer::regchange(
		uint32_t			reg,
		uint32_t			val
		)
{
	m_regs[reg] = val;
	fprintf(m_fp, "REG_CHANGE: %d 0x%08x\n", reg, val);
}
