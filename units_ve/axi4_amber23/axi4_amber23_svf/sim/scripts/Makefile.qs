
include $(SOCBLOX)/defs.mk

UNIT_VE=axi4_amber23_svf
TB=$(UNIT_VE)_tb

AXI4_AMBER23_SVF=$(SOCBLOX)/units_ve/axi4_amber23/$(UNIT_VE)
AXI4_A23_DIR=$(AXI4_AMBER23_SVF)
include $(AXI4_AMBER23_SVF)/tests/sw/defs.mk
include $(AXI4_AMBER23_SVF)/svf/a23_tracer/defs.mk
include $(AXI4_AMBER23_SVF)/tests/defs.mk
include $(AXI4_AMBER23_SVF)/tb/defs.mk

SCCOM_INCLUDES += -I$(SOCBLOX)/svf 
SCCOM_INCLUDES += -I$(SOCBLOX)/common/bfm/axi4_svf
SCCOM_INCLUDES += -I$(SOCBLOX)/common/bfm/axi4_svf_sram
SCCOM_INCLUDES += -I$(SOCBLOX)/common/svf
SCCOM_INCLUDES += -I$(AXI4_SVF)/tb -I$(AXI4_SVF)/tests
SCCOM_INCLUDES += -I$(BUILD_DIR)
SCCOM_INCLUDES += -DQUESTA
CXXFLAGS += -DQUESTA

#	scgenmod -bool $(TB) > $(TB)_wrapper.h
#	sccom $(SCCOM_INCLUDES) -std=c++0x -Di386 $(AXI4_AMBER23_SVF)/tb/axi4_amber23_svf_tb.cpp
#	sccom -link -L$(SOCBLOX_LIBDIR) \
#          	$(BFM_AXI4_SVF_SRAM_LINK) \
#          	$(COMMON_SVF_LINK) \
#          	$(LIBSVF_SC_QS_LINK)


all : $(LIB_TARGETS) $(TARGET_EXE_TARGETS) $(BUILD_DIR)/libs/liba23_dpi.so
	vlib work
	vlog -sv \
		$(SOCBLOX)/svf/dpi/svf_dpi_pkg.sv  \
		-f $(AXI4_AMBER23_SVF)/sim/scripts/axi4_amber23_svf.f
	vopt -o $(TB)_opt $(TB) -dpiheader foo.h

$(BUILD_DIR)/libs/liba23_dpi.so : $(A23_TESTBENCH_OBJS)
	if test ! -d $(BUILD_DIR)/libs; then mkdir -p $(BUILD_DIR)/libs; fi
	$(CXX) -o $@ -shared $^ $(LIBSVF_LINK) \
		-L$(SOCBLOX_LIBDIR) \
          	$(COMMON_SVF_LINK) \
		$(BFM_AXI4_SVF_SRAM_LINK) 

include $(SOCBLOX)/rules.mk
include $(AXI4_AMBER23_SVF)/tests/sw/rules.mk
include $(AXI4_AMBER23_SVF)/svf/a23_tracer/rules.mk
include $(AXI4_AMBER23_SVF)/tests/rules.mk
include $(AXI4_AMBER23_SVF)/tb/rules.mk
