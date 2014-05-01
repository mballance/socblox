
#MK_INCLUDES += $(SOCBLOX)/common/bfm/axi4_rom/defs_rules.mk
#MK_INCLUDES += $(SOCBLOX)/common/bfm/axi4_svf_sram/defs_rules.mk
#MK_INCLUDES += $(SOCBLOX)/common/bfm/uart/defs_rules.mk

COMMON_DIR=$(SOCBLOX)/common
COMMON_BFMS=$(COMMON_DIR)/bfm

MK_INCLUDES += $(COMMON_DIR)/../svf/svf_defs.mk
MK_INCLUDES += $(COMMON_BFMS)/generic_sram_byte_en/defs_rules.mk
MK_INCLUDES += $(COMMON_BFMS)/generic_rom/defs_rules.mk
MK_INCLUDES += $(COMMON_SIM_MK_DIR)/common_target_defs_rules.mk
MK_INCLUDES += $(COMMON_SIM_MK_DIR)/svf/defs_rules.mk
MK_INCLUDES += $(SOCBLOX)/esw/a23_common/defs_rules.mk
MK_INCLUDES += $(SIM_DIR)/../tests/sw/defs_rules.mk
MK_INCLUDES += $(SIM_DIR)/../tb/defs_rules.mk 
MK_INCLUDES += $(SIM_DIR)/../tests/defs_rules.mk

UNIT_VE=a23_dualcore_sys
TB=$(UNIT_VE)_tb

TARGET=arm-none-eabi
TARGET_CC=$(TARGET)-gcc
TARGET_CXX=$(TARGET)-g++
TARGET_LD=$(TARGET)-ld
TARGET_OBJDUMP=$(TARGET)-objdump
TARGET_CFLAGS +=-march=armv2a -mno-thumb-interwork 
TARGET_LDFLAGS +=-Bstatic --fix-v4bx -nostartfiles

TARGET_CFLAGS += -g

TARGET_CXXFLAGS += $(TARGET_CFLAGS)

BFMS += SVF_AXI4_SRAM SVF_AXI4_ROM UART_BFM COMMON_SVF
BFMS += A23_TRACER

VERILATOR_TRACE_EN ?= 1

include $(SOCBLOX)/common/common_sim.mk



