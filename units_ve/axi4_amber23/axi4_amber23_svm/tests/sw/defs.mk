
A23_CORE_TESTS_DIR=$(AXI4_AMBER23_SVM)/tests/sw
A23_CORE_TESTS_SRC=\
	adc.S \
	add.S \
	
A23_CFLAGS=-march=armv2a -mno-thumb-interwork 
A23_LDFLAGS=-Bstatic --fix-v4bx 

A23_CFLAGS += -I$(A23_CORE_TESTS_DIR)
	
A23_CORE_TESTS=$(foreach e,$(A23_CORE_TESTS_SRC:.S=.elf),$(BUILD_DIR)/core_tests/$(e))

TARGET_EXE_TARGETS += $(A23_CORE_TESTS)
