
include $(SOCBLOX)/defs.mk

UNIT_VE=axi4_interconnect_2x2
TB=$(UNIT_VE)_tb

ifeq ($(SIMX),1)
include V$(TB).mk
endif

AXI4_2X2_DIR=$(SOCBLOX)/units_ve/interconnects/axi4_svm
#include $(AXI4_AMBER23_SVM)/tests/sw/defs.mk
#include $(AXI4_AMBER23_SVM)/svm/a23_tracer/defs.mk
#include $(AXI4_AMBER23_SVM)/tests/defs.mk
#include $(AXI4_AMBER23_SVM)/tb/defs.mk

CXXFLAGS += -I$(SYSTEMC)/include -I$(SOCBLOX)/svm 
#CXXFLAGS += -I$(SOCBLOX)/common/bfm/axi4_svm
CXXFLAGS += -I$(BUILD_DIR)/obj_dir
CXXFLAGS += -I$(VERILATOR_ROOT)/include
CXXFLAGS += -I$(VERILATOR_ROOT)/include/vltstd

#CXXFLAGS += -I$(AXI4_SVM)/tb -I$(AXI4_SVM)/tests


SV_SRC = \
 $(SOCBLOX)/common/rtl/axi4/axi4_if.sv \
 $(SOCBLOX)/common/bfm/axi4_svm/axi4_svm_master_bfm.sv \
 $(SOCBLOX)/units_ve/interconnects/axi4_svm/tb/axi4_interconnect_2x2_tb.sv \

all : $(LIB_TARGETS) $(TARGET_EXE_TARGETS)
	verilator --trace --sc --Wno-fatal \
		--top-module $(TB) -f $(SIM_DIR)/scripts/$(UNIT_VE).f
	$(MAKE) SIMX=1 -C obj_dir -f $(SIM_DIR)/scripts/Makefile $(BUILD_DIR)/simx 


$(BUILD_DIR)/simx : $(VK_GLOBAL_OBJS) \
	V$(TB)__ALL.a \
	$(BFM_AXI4_SVM_SRAM_LIB) \
	$(COMMON_SVM_LIB) \
	$(AXI4_2X2_DIR)/tb/$(TB).cpp \
	$(A23_TESTBENCH_OBJS)
	$(CXX) $(CXXFLAGS) -o $(BUILD_DIR)/simx \
	  $(AXI4_2X2_DIR)/tb/$(TB).cpp \
	      $(A23_TESTBENCH_OBJS) \
	      -Wl,--whole-archive \
          V$(TB)__ALL.a \
	      -Wl,--no-whole-archive \
          $(VK_GLOBAL_OBJS) \
          -L$(SOCBLOX_LIBDIR) \
          	$(BFM_AXI4_SVM_SRAM_LINK) \
          	$(AXI4_SVM_BFM_LINK) \
          	$(COMMON_SVM_LINK) \
          	$(LIBSVM_SC_LINK) \
	  $(SYSTEMC)/lib-linux/libsystemc.a -lpthread

include $(SOCBLOX)/rules.mk
#include $(AXI4_AMBER23_SVM)/tests/sw/rules.mk
#include $(AXI4_AMBER23_SVM)/svm/a23_tracer/rules.mk
#include $(AXI4_AMBER23_SVM)/tests/rules.mk
#include $(AXI4_AMBER23_SVM)/tb/rules.mk
