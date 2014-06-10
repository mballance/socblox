
TOP_MODULE ?= $(TB)
DEBUG ?= false
TIMEOUT ?= 1ms

COMMON_SIM_MK := $(lastword $(MAKEFILE_LIST))
COMMON_SIM_MK_DIR := $(dir $(COMMON_SIM_MK))
export COMMON_SIM_MK_DIR

DLLEXT=.so
LIBPREF=lib
SVF_LIBDIR ?= $(BUILD_DIR)/libs
SVF_OBJDIR ?= $(BUILD_DIR)/objs

COMMON_BFM ?= $(SOCBLOX)/common/bfm
COMMON_RTL ?= $(SOCBLOX)/common/rtl
UNITS ?= $(SOCBLOX)/units
SYSTEMS ?= $(SOCBLOX)/systems

export COMMON_BFM
export COMMON_RTL
export UNITS
export SYSTEMS

SVF_BUILD_HOST_WRAPPERS := 0

ifeq (qs,$(SIM))
SVF_BUILD_SIM_SC_WRAPPER := 0
endif


# include $(SOCBLOX)/defs.mk
include $(COMMON_SIM_MK_DIR)/common_defs.mk
include $(MK_INCLUDES)

CXXFLAGS += -I$(SOCBLOX)/svf
CXXFLAGS += $(foreach dir, $(SRC_DIRS), -I$(dir))

BFM_LIBS += $(foreach bfm, $(BFMS), $($(bfm)_LIB))
# CXXFLAGS += $(foreach bfm, $(BFMS), -I$($(bfm)_DIR))

LIB_TARGETS += $(BFM_LIBS)

vpath %.cpp $(SRC_DIRS)
vpath %.S $(SRC_DIRS)
vpath %.c $(SRC_DIRS)

.phony: all build run target_build

all :
	echo "Error: Specify target of build or run
	exit 1

include $(COMMON_SIM_MK_DIR)/sim_mk/common_sim_$(SIM).mk	

target_build :
	if test "x$(TARGET_MAKEFILE)" != "x"; then \
		$(MAKE) -f $(TARGET_MAKEFILE) build; \
	fi

QS_VLOG_ARGS += $(SOCBLOX)/svf/dpi/svf_pkg.sv
VL_VLOG_ARGS += $(SOCBLOX)/svf/sc/svf_pkg.sv
VLOG_ARGS += -F $(SIM_DIR)/scripts/vlog.F


LD_LIBRARY_PATH := $(BUILD_DIR)/libs:$(LD_LIBRARY_PATH)
# LD_LIBRARY_PATH := $(SOCBLOX)/libs/$(PLATFORM):$(LD_LIBRARY_PATH)

LD_LIBRARY_PATH := $(foreach path,$(BFM_LIBS),$(dir $(path)):)$(LD_LIBRARY_PATH)
export LD_LIBRARY_PATH

RULES := 1
# include $(SOCBLOX)/rules.mk
include $(COMMON_SIM_MK_DIR)/common_rules.mk
include $(MK_INCLUDES)

$(SVF_OBJDIR)/%.o : %.cpp
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(CXX) -c -o $@ $(CXXFLAGS) $^
	
$(SVF_LIBDIR)/%.a : 
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	rm -f $@
	ar vcq $@ $^
	
$(SVF_LIBDIR)/sc/%.so : 
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(LINK) -shared -o $@ $^
	
$(SVF_LIBDIR)/dpi/%.so : 
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(LINK) -shared -o $@ $^
	
$(SVF_LIBDIR)/sc_qs/%.so : 
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(LINK) -shared -o $@ $^

	