#****************************************************************************
#* 
#****************************************************************************
	
MK_INCLUDES += $(SIM_DIR)/../tests/sw/defs_rules.mk
MK_INCLUDES += $(SOCBLOX)/esw/a23_common/defs_rules.mk
MK_INCLUDES += $(COMMON_SIM_MK_DIR)/common_target_defs_rules.mk

TARGET=arm-none-eabi

CFLAGS +=-march=armv2a -mno-thumb-interwork 
LDFLAGS +=-Bstatic --fix-v4bx -nostartfiles

CFLAGS += -g

CXXFLAGS += $(TARGET_CFLAGS) -fno-rtti -fno-exceptions -Wall

include $(COMMON_SIM_MK_DIR)/common_sim_target.mk


