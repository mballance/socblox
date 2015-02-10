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
SVF_BUILD_UTH_WRAPPERS := 1

MK_INCLUDES += $(COMMON_SIM_MK_DIR)/../units/timer/sw/defs_rules.mk
MK_INCLUDES += $(COMMON_SIM_MK_DIR)/../units/interrupt_controller/sw/defs_rules.mk

MK_INCLUDES += $(SIM_DIR)/../tests/sw/defs_rules.mk
MK_INCLUDES += $(SIM_DIR)/../tests/sw/defs_rules.mk
# MK_INCLUDES += $(SOCBLOX)/esw/a23_common/defs_rules.mk
MK_INCLUDES += $(SOCBLOX)/esw/a23_uex_hal/defs_rules.mk
MK_INCLUDES += $(SOCBLOX)/esw/uex/defs_rules.mk
MK_INCLUDES += $(SOCBLOX)/esw/uth/defs_rules.mk
MK_INCLUDES += $(SOCBLOX)/esw/uth_a23/defs_rules.mk
MK_INCLUDES += $(SOCBLOX)/esw/uth_coop_thread_mgr/defs_rules.mk
MK_INCLUDES += $(SOCBLOX)/esw/a23_boot/defs_rules.mk
MK_INCLUDES += $(COMMON_SIM_MK_DIR)/common_target_defs_rules.mk
MK_INCLUDES += $(COMMON_SIM_MK_DIR)/../svf/svf_defs.mk
MK_INCLUDES += $(UNITS)/bidi_message_queue/sw/defs_rules.mk
MK_INCLUDES += $(UNITS)/bidi_message_queue/sw/uth/defs_rules.mk
MK_INCLUDES += $(SYSTEMS)/a23_dualcore_sys/sw/preloader/defs_rules.mk
MK_INCLUDES += $(SYSTEMS)/a23_dualcore_sys/sw/preloader_app/defs_rules.mk
MK_INCLUDES += $(SOCBLOX)/esw/preloader/defs_rules.mk

# Bring in the list of dependencies
# TARGET_EXE_LIST := $(shell $(COMMON_SIM_MK_DIR)/scripts/collect_target_exe.pl $(BUILD_DIR)/testlist.f)
# EXE_TARGETS += $(TARGET_EXE_LIST)


SRC_DIRS += $(SOCBLOX)/systems/a23_dualcore/sw

TARGET=arm-none-eabi

CFLAGS +=-march=armv2a -mno-thumb-interwork 
LDFLAGS +=-Bstatic --fix-v4bx -nostartfiles

#CFLAGS += -g -O3
CFLAGS += -g 

CXXFLAGS += $(CFLAGS) -fno-rtti -fno-exceptions -Wall

include $(COMMON_SIM_MK_DIR)/common_sim_target.mk


