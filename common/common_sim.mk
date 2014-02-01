
TOP_MODULE ?= $(TB)

COMMON_SIM_MK := $(lastword $(MAKEFILE_LIST))
COMMON_SIM_MK_DIR := $(dir $(COMMON_SIM_MK))

include $(SOCBLOX)/defs.mk
include $(COMMON_SIM_MK_DIR)/common_target_defs_rules.mk

MK_INCLUDES += \
	$(SIM_DIR)/../tb/defs_rules.mk \
	$(SIM_DIR)/../tests/defs_rules.mk

include $(MK_INCLUDES)

CXXFLAGS += -I$(SOCBLOX)/svf
CXXFLAGS += $(foreach dir, $(SRC_DIRS), -I$(dir))

BFM_LIBS += $(foreach bfm, $(BFMS), $($(bfm)_LIB))
CXXFLAGS += $(foreach bfm, $(BFMS), -I$($(bfm)_DIR))

LIB_TARGETS += $(BFM_LIBS)

vpath %.cpp $(SRC_DIRS)
vpath %.S $(SRC_DIRS)
vpath %.c $(SRC_DIRS)

.phony: vlog_build

#********************************************************************
#* Compile rules
#********************************************************************
ifeq ($(SIM),qs) 
LIB_TARGETS += $(BUILD_DIR)/libs/tb_dpi.so
endif

ifeq ($(SIM),vl)
CXXFLAGS += -I$(SYSTEMC)/include -I$(SOCBLOX)/svf/sc
CXXFLAGS += -I$(BUILD_DIR)/obj_dir
CXXFLAGS += -I$(VERILATOR_ROOT)/include
CXXFLAGS += -I$(VERILATOR_ROOT)/include/vltstd

ifeq (1,$(VERILATOR_TRACE_EN))
CXXFLAGS += -DVL_TRACE_EN
endif

endif

compile : $(LIB_TARGETS) $(TARGET_EXE_TARGETS) $(TESTBENCH_OBJS) vlog_build

QS_VLOG_ARGS += $(SOCBLOX)/svf/dpi/svf_pkg.sv
VL_VLOG_ARGS += $(SOCBLOX)/svf/sc/svf_pkg.sv
VLOG_ARGS += -f $(SIM_DIR)/scripts/vlog.f

ifeq ($(SIM),qs)
DPI_LIBS += $(SOCBLOX)/libs/$(PLATFORM)/dpi/libsvf_dpi
DPI_LIBS += $(BUILD_DIR)/libs/tb_dpi
else
#********************************************************************
ifeq ($(SIM),vl)
else
endif
endif

ifeq ($(SIM),qs)
vlog_build :
	rm -rf work
	vlib work
	vlog -sv \
		$(QS_VLOG_ARGS) \
		$(VLOG_ARGS)
	vopt -o $(TB)_opt $(TB) -dpiheader foo.h

$(BUILD_DIR)/libs/tb_dpi.so : $(TESTBENCH_OBJS) $(BFM_LIBS) $(LIBSVF)
	if test ! -d $(BUILD_DIR)/libs; then mkdir -p $(BUILD_DIR)/libs; fi
	$(CXX) -o $@ -shared $(filter %.o, $^) \
		$(foreach l,$(filter %.so, $^), -L$(dir $(l)) -l$(subst lib,,$(basename $(notdir $(l))))) \
		$(LIBSVF_LINK)
else
ifeq ($(SIM),vl)

ifeq ($(SIMX),1)
include V$(TB).mk
endif

ifeq (1,$(VERILATOR_TRACE_EN))
TRACE=--trace
endif

vlog_build :
	rm -rf obj_dir
	verilator $(TRACE) --sc -Wno-fatal \
		--top-module $(TOP_MODULE) \
		$(VL_VLOG_ARGS) \
		$(VLOG_ARGS) 

compile : 
	$(MAKE) SOCBLOX=$(SOCBLOX) TB=$(TB) SIMX=1 TESTBENCH_OBJS="$(TESTBENCH_OBJS)" \
	    VERILATOR_TRACE_EN=$(VERILATOR_TRACE_EN) BFM_LIBS="$(BFM_LIBS)" \
	    LIBSVF_LINK="$(LIBSVF_LINK)" \
	    LIBSVF_SC_LINK="$(LIBSVF_SC_LINK)" \
	    -C obj_dir -f $(COMMON_SIM_MK) \
		$(BUILD_DIR)/simx

$(BUILD_DIR)/simx : $(VK_GLOBAL_OBJS) V$(TB)__ALL.a $(BUILD_DIR)/objs/$(TB).o
	$(CXX) -o $(BUILD_DIR)/simx \
	    	$(BUILD_DIR)/objs/$(TB).o \
			$(TESTBENCH_OBJS) \
			-Wl,--whole-archive \
			V$(TB)__ALL.a \
			-Wl,--no-whole-archive \
			$(VK_GLOBAL_OBJS) \
			$(foreach l,$(filter %.so, $(BFM_LIBS)), -L$(dir $(l)) -l$(subst lib,,$(basename $(notdir $(l))))) \
			$(LIBSVF_SC_LINK) \
			$(SYSTEMC)/lib-linux/libsystemc.a -lpthread
			
endif
endif

LD_LIBRARY_PATH := $(BUILD_DIR)/libs:$(LD_LIBRARY_PATH)
LD_LIBRARY_PATH := $(SOCBLOX)/libs/$(PLATFORM):$(LD_LIBRARY_PATH)

ifeq ($(SIM),qs)
LD_LIBRARY_PATH := $(SOCBLOX)/libs/$(PLATFORM)/dpi:$(LD_LIBRARY_PATH)
endif

ifeq ($(SIM),vl)
LD_LIBRARY_PATH := $(SOCBLOX)/libs/$(PLATFORM)/sc:$(LD_LIBRARY_PATH)
endif

LD_LIBRARY_PATH := $(foreach path,$(BFM_LIBS),$(dir $(path)):)$(LD_LIBRARY_PATH)
export LD_LIBRARY_PATH

.phony: run

ifeq ($(SIM),qs)
run : 
	vmap work ${BUILD_DIR}/work
	vsim -c -do "run 1ms; quit -f" $(UNIT_VE)_tb_opt \
		+TESTNAME=$(TESTNAME) $(ARGFILE) \
		$(foreach dpi,$(DPI_LIBS),-sv_lib $(dpi))
else
ifeq ($(SIM),vl)
run : 
	$(BUILD_DIR)/simx +TESTNAME=$(TESTNAME) $(ARGFILE)
endif
endif

RULES := 1
include $(COMMON_SIM_MK_DIR)/common_target_defs_rules.mk
include $(MK_INCLUDES)
include $(SOCBLOX)/rules.mk

$(BUILD_DIR)/objs/%.o : %.cpp
	if test ! -d $(BUILD_DIR)/objs; then mkdir -p $(BUILD_DIR)/objs; fi
	$(CXX) -c -o $@ $(CXXFLAGS) $^

