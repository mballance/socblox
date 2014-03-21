
TOP_MODULE ?= $(TB)
DEBUG ?= false
TIMEOUT ?= 1ms

COMMON_SIM_MK := $(lastword $(MAKEFILE_LIST))
COMMON_SIM_MK_DIR := $(dir $(COMMON_SIM_MK))

include $(SOCBLOX)/defs.mk
include $(MK_INCLUDES)

CXXFLAGS += -I$(SOCBLOX)/svf
CXXFLAGS += $(foreach dir, $(SRC_DIRS), -I$(dir))

BFM_LIBS += $(foreach bfm, $(BFMS), $($(bfm)_LIB))
CXXFLAGS += $(foreach bfm, $(BFMS), -I$($(bfm)_DIR))

LIB_TARGETS += $(BFM_LIBS)

vpath %.cpp $(SRC_DIRS)
vpath %.S $(SRC_DIRS)
vpath %.c $(SRC_DIRS)

.phony: all build run vlog_build

all :
	echo "Error: Specify target of build or run
	exit 1

include $(COMMON_SIM_MK_DIR)/sim_mk/common_sim_$(SIM).mk	

build : $(LIB_TARGETS) $(TARGET_EXE_TARGETS) $(TESTBENCH_OBJS) vlog_build

QS_VLOG_ARGS += $(SOCBLOX)/svf/dpi/svf_pkg.sv
VL_VLOG_ARGS += $(SOCBLOX)/svf/sc/svf_pkg.sv
VLOG_ARGS += -f $(SIM_DIR)/scripts/vlog.f


LD_LIBRARY_PATH := $(BUILD_DIR)/libs:$(LD_LIBRARY_PATH)
LD_LIBRARY_PATH := $(SOCBLOX)/libs/$(PLATFORM):$(LD_LIBRARY_PATH)

LD_LIBRARY_PATH := $(foreach path,$(BFM_LIBS),$(dir $(path)):)$(LD_LIBRARY_PATH)
export LD_LIBRARY_PATH

RULES := 1
include $(SOCBLOX)/rules.mk
include $(MK_INCLUDES)

$(BUILD_DIR)/objs/%.o : %.cpp
	if test ! -d $(BUILD_DIR)/objs; then mkdir -p $(BUILD_DIR)/objs; fi
	$(CXX) -c -o $@ $(CXXFLAGS) $^

