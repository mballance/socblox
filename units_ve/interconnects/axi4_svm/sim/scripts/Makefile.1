
ifeq ($(SIMX),1)
include Vaxi4_interconnect_2x2_tb.mk
endif

AXI4_SVM=$(SOCBLOX)/units_ve/interconnects/axi4_svm

CXXFLAGS += -I$(SYSTEMC)/include -I$(SOCBLOX)/svm 
CXXFLAGS += -I$(SOCBLOX)/common/bfm/axi4_svm
CXXFLAGS += -I$(BUILD_DIR)/obj_dir
CXXFLAGS += -I$(VERILATOR_ROOT)/include
CXXFLAGS += -I$(VERILATOR_ROOT)/include/vltstd

CXXFLAGS += -I$(AXI4_SVM)/tb -I$(AXI4_SVM)/tests


SV_SRC = \
 $(SOCBLOX)/common/rtl/axi4/axi4_if.sv \
 $(SOCBLOX)/common/bfm/axi4/axi4_master_bfm.sv \
 $(SOCBLOX)/common/bfm/axi4_svm/svm_axi4_master_bfm.sv \
 $(SOCBLOX)/units_ve/interconnects/axi4_svm/tb/axi4_interconnect_2x2_tb.sv \

SVM_SRC = \
 axi4_interconnect_env.cpp \
 axi4_interconnect_test_base.cpp \

SVM_OBJS=$(foreach o,$(SVM_SRC:.cpp=.o),$(BUILD_DIR)/$(o))

all : $(SV_SRC)
	$(MAKE) -C $(SOCBLOX)
	verilator --trace --sc --Wno-fatal \
		--top-module axi4_interconnect_2x2_tb $(SV_SRC)
	$(MAKE) SIMX=1 -C obj_dir -f $(SIM_DIR)/scripts/Makefile \
		$(BUILD_DIR)/simx

$(BUILD_DIR)/simx : $(VK_GLOBAL_OBJS) \
	Vaxi4_interconnect_2x2_tb__ALL.a \
	$(BUILD_DIR)/axi4_svm.a \
	$(SOCBLOX)/units_ve/interconnects/axi4_svm/tb/axi4_interconnect_tb.cpp
	$(CXX) $(CXXFLAGS) -o $(BUILD_DIR)/simx \
      -Wl,--whole-archive \
      $(BUILD_DIR)/axi4_svm.a \
      -Wl,--no-whole-archive \
	  $(SOCBLOX)/units_ve/interconnects/axi4_svm/tb/axi4_interconnect_tb.cpp \
          Vaxi4_interconnect_2x2_tb__ALL.a \
          $(VK_GLOBAL_OBJS) \
          -L$(SOCBLOX)/libs/linux -lsvm_axi4_bfm -lsvm -lsvm_sc \
	  $(SYSTEMC)/lib-linux/libsystemc.a -lpthread

$(BUILD_DIR)/axi4_svm.a : $(SVM_OBJS)
	rm -f $@
	$(AR) vcq $@ $^
	
$(BUILD_DIR)/%.o : $(AXI4_SVM)/tests/%.cpp
	$(CXX) -c -o $@ $(CXXFLAGS) $^
	
$(BUILD_DIR)/%.o : $(AXI4_SVM)/tb/%.cpp
	$(CXX) -c -o $@ $(CXXFLAGS) $^
