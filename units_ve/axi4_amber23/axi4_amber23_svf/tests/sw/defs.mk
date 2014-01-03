
A23_CORE_TESTS_DIR=$(AXI4_AMBER23_SVF)/tests/sw
A23_CORE_TESTS_SRC=\
	adc.S \
	add.S \
	\
	barrel_shift_rs.S \
	barrel_shift.S \
	\
	bcc.S \
	bic_bug.S \
	bl.S \
	\
	ldm1.S \
	ldm2.S \
	ldm3.S \
	ldm4.S \
	ldr.S
	
A23_CFLAGS=-march=armv2a -mno-thumb-interwork 
A23_LDFLAGS=-Bstatic --fix-v4bx 

A23_CFLAGS += -I$(A23_CORE_TESTS_DIR) -g
	
A23_CORE_TESTS=$(foreach e,$(A23_CORE_TESTS_SRC:.S=.elf),$(BUILD_DIR)/core_tests/$(e))
A23_CORE_TESTS_DIS=$(foreach e,$(A23_CORE_TESTS_SRC:.S=.dis),$(BUILD_DIR)/core_tests/$(e))

TARGET_EXE_TARGETS += $(A23_CORE_TESTS) $(A23_CORE_TESTS_DIS)
