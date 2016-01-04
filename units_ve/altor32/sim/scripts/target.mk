#****************************************************************************
#* target.mk
#*
#* TODO: 
#****************************************************************************

SVF_OBJDIR = $(BUILD_DIR)/target/objs
SVF_LIBDIR = $(BUILD_DIR)/target/libs

SVF_BUILD_CORE_DLL := 0
SVF_BUILD_SIM_WRAPPERS := 0
SVF_BUILD_HOST_WRAPPERS := 0

MK_INCLUDES += $(COMMON_SIM_MK_DIR)/../units/timer/sw/defs_rules.mk
	
MK_INCLUDES += $(SIM_DIR)/../tests/sw/defs_rules.mk
# MK_INCLUDES += $(SOCBLOX)/esw/a23_common/defs_rules.mk
MK_INCLUDES += $(COMMON_SIM_MK_DIR)/common_target_defs_rules.mk
# MK_INCLUDES += $(COMMON_SIM_MK_DIR)/../svf/svf_defs.mk

TARGET=or1knd-elf

# CFLAGS +=-march=armv2a -mno-thumb-interwork 
# LDFLAGS +=-Bstatic --fix-v4bx -nostartfiles
CFLAGS += -msoft-div -msoft-float -msoft-mul -mno-ror -mno-cmov -mno-sext

CFLAGS += -g

CXXFLAGS += $(TARGET_CFLAGS) -fno-rtti -fno-exceptions -Wall

include $(COMMON_SIM_MK_DIR)/common_sim_target.mk


