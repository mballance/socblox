
ifeq ($(SIMX),1)
include Vaxi4_interconnect_2x2_tb.mk
endif

CXXFLAGS += -I$(SYSTEMC)/include -I$(SOCBLOX)/svm 
CXXFLAGS += -I$(SOCBLOX)/common/bfm/axi4_svm
CXXFLAGS += -I$(BUILD_DIR)/obj_dir
CXXFLAGS += -I$(VERILATOR_ROOT)/include
CXXFLAGS += -I$(VERILATOR_ROOT)/include/vltstd

SV_SRC = \
 $(SOCBLOX)/common/rtl/axi4/axi4_if.sv \
 $(SOCBLOX)/common/bfm/axi4/axi4_master_bfm.sv \
 $(SOCBLOX)/common/bfm/axi4_svm/svm_axi4_master_bfm.sv \
 $(SOCBLOX)/units_ve/interconnects/axi4_svm/tb/axi4_interconnect_2x2_tb.sv \



all : $(SV_SRC)
	$(MAKE) -C $(SOCBLOX)
	verilator --trace --sc --Wno-fatal \
		--top-module axi4_interconnect_2x2_tb $(SV_SRC)
	$(MAKE) SIMX=1 -C obj_dir -f $(SIM_DIR)/scripts/Makefile \
		$(BUILD_DIR)/simx

$(BUILD_DIR)/simx : $(VK_GLOBAL_OBJS) \
	Vaxi4_interconnect_2x2_tb__ALL.a \
	$(SOCBLOX)/units_ve/interconnects/axi4_svm/tb/axi4_interconnect_tb.cpp
	$(CXX) $(CXXFLAGS) -o $(BUILD_DIR)/simx \
	  $(SOCBLOX)/units_ve/interconnects/axi4_svm/tb/axi4_interconnect_tb.cpp \
          Vaxi4_interconnect_2x2_tb__ALL.a \
          $(VK_GLOBAL_OBJS) \
          -L$(SOCBLOX)/libs/linux -lsvm_axi4_bfm -lsvm -lsvm_sc \
	  $(SYSTEMC)/lib-linux/libsystemc.a -lpthread



