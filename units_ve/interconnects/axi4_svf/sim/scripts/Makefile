
include $(SOCBLOX)/defs.mk

UNIT_VE=axi4_interconnect_2x2
TB=$(UNIT_VE)_tb

ifeq ($(SIMX),1)
include V$(TB).mk
endif

AXI4_2X2_DIR=$(SOCBLOX)/units_ve/interconnects/axi4_svf
include $(SIM_DIR)/../tests/defs_rules.mk
include $(SIM_DIR)/../tb/defs_rules.mk
#include $(AXI4_AMBER23_SVF)/tests/sw/defs.mk
#include $(AXI4_AMBER23_SVF)/svf/a23_tracer/defs.mk
#include $(AXI4_AMBER23_SVF)/tests/defs.mk
#include $(AXI4_AMBER23_SVF)/tb/defs.mk

CXXFLAGS += -I$(SYSTEMC)/include -I$(SOCBLOX)/svf 
#CXXFLAGS += -I$(SOCBLOX)/common/bfm/axi4_svf
CXXFLAGS += -I$(BUILD_DIR)/obj_dir
CXXFLAGS += -I$(VERILATOR_ROOT)/include
CXXFLAGS += -I$(VERILATOR_ROOT)/include/vltstd

#CXXFLAGS += -I$(AXI4_SVF)/tb -I$(AXI4_SVF)/tests


SV_SRC = \
 $(SOCBLOX)/common/rtl/axi4/axi4_if.sv \
 $(SOCBLOX)/common/bfm/axi4_svf/axi4_svf_master_bfm.sv \
 $(SOCBLOX)/units_ve/interconnects/axi4_svf/tb/axi4_interconnect_2x2_tb.sv \

all : $(LIB_TARGETS) $(TARGET_EXE_TARGETS)
	verilator --trace --sc --Wno-fatal \
		--top-module $(TB) -f $(SIM_DIR)/scripts/$(UNIT_VE).f
	$(MAKE) SIMX=1 -C obj_dir -f $(SIM_DIR)/scripts/Makefile $(BUILD_DIR)/simx 


$(BUILD_DIR)/simx : $(VK_GLOBAL_OBJS) \
	V$(TB)__ALL.a \
	$(BFM_AXI4_SVF_SRAM_LIB) \
	$(COMMON_SVF_LIB) \
	$(AXI4_2X2_DIR)/tb/$(TB).cpp \
	$(TESTBENCH_OBJS)
	$(CXX) $(CXXFLAGS) -o $(BUILD_DIR)/simx \
	  $(AXI4_2X2_DIR)/tb/$(TB).cpp \
	      $(TESTBENCH_OBJS) \
	      -Wl,--whole-archive \
          V$(TB)__ALL.a \
	      -Wl,--no-whole-archive \
          $(VK_GLOBAL_OBJS) \
          -L$(SOCBLOX_LIBDIR) \
          	$(BFM_AXI4_SVF_SRAM_LINK) \
          	$(AXI4_SVF_BFM_LINK) \
          	$(COMMON_SVF_LINK) \
          	$(LIBSVF_SC_LINK) \
	  $(SYSTEMC)/lib-linux/libsystemc.a -lpthread

RULES := 1
include $(SOCBLOX)/rules.mk
include $(SIM_DIR)/../tests/defs_rules.mk
include $(SIM_DIR)/../tb/defs_rules.mk
#include $(AXI4_AMBER23_SVF)/tests/sw/rules.mk
#include $(AXI4_AMBER23_SVF)/svf/a23_tracer/rules.mk
#include $(AXI4_AMBER23_SVF)/tests/rules.mk
#include $(AXI4_AMBER23_SVF)/tb/rules.mk
