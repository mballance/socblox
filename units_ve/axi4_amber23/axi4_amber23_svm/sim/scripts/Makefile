
include $(SOCBLOX)/defs.mk

UNIT_VE=axi4_amber23_svm
TB=$(UNIT_VE)_tb

ifeq ($(SIMX),1)
include V$(TB).mk
endif

AXI4_AMBER23_SVM=$(SOCBLOX)/units_ve/axi4_amber23/$(UNIT_VE)
include $(AXI4_AMBER23_SVM)/tests/sw/defs.mk
include $(AXI4_AMBER23_SVM)/svm/a23_tracer/defs.mk

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

#SVM_SRC = \
# axi4_interconnect_env.cpp \
# axi4_interconnect_test_base.cpp \

#SVM_OBJS=$(foreach o,$(SVM_SRC:.cpp=.o),$(BUILD_DIR)/$(o))

all : $(LIB_TARGETS) $(TARGET_EXE_TARGETS)
	verilator --trace --sc --Wno-fatal \
		--top-module $(TB) -f $(AXI4_AMBER23_SVM)/sim/scripts/axi4_amber23_svm.f
	$(MAKE) SIMX=1 -C obj_dir -f $(SIM_DIR)/scripts/Makefile \
		$(BUILD_DIR)/simx
		
#          	-lsvm_axi4_bfm \


$(BUILD_DIR)/simx : $(VK_GLOBAL_OBJS) \
	V$(TB)__ALL.a \
	$(BFM_AXI4_SVM_SRAM_LIB) \
	$(COMMON_SVM_LIB) \
	$(AXI4_AMBER23_SVM)/tb/$(TB).cpp
	$(CXX) $(CXXFLAGS) -o $(BUILD_DIR)/simx \
	  $(AXI4_AMBER23_SVM)/tb/$(TB).cpp \
	      -Wl,--whole-archive \
          V$(TB)__ALL.a \
	      -Wl,--no-whole-archive \
          $(VK_GLOBAL_OBJS) \
          -L$(SOCBLOX_LIBDIR) \
          	$(BFM_AXI4_SVM_SRAM_LINK) \
          	$(COMMON_SVM_LINK) \
          	$(LIBSVM_SC_LINK) \
          $(A23_TRACER_LINK) \
	  $(SYSTEMC)/lib-linux/libsystemc.a -lpthread

$(BUILD_DIR)/axi4_amber23_svm.a : $(SVM_OBJS)
	rm -f $@
	$(AR) vcq $@ $^
	
#$(BUILD_DIR)/%.o : $(AXI4_SVM)/tests/%.cpp
#	$(CXX) -c -o $@ $(CXXFLAGS) $^
	
#$(BUILD_DIR)/%.o : $(AXI4_SVM)/tb/%.cpp
#	$(CXX) -c -o $@ $(CXXFLAGS) $^

include $(SOCBLOX)/rules.mk
include $(AXI4_AMBER23_SVM)/tests/sw/rules.mk
include $(AXI4_AMBER23_SVM)/svm/a23_tracer/rules.mk
