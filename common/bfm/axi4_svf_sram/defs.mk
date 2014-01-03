
BFM_AXI4_SVF_SRAM_DIR=$(SOCBLOX)/common/bfm/axi4_svf_sram
CXXFLAGS += -I$(BFM_AXI4_SVF_SRAM_DIR)

BFM_AXI4_SVF_SRAM_SRC=\
	axi4_svf_sram_dpi_mgr.cpp \
	axi4_svf_sram_bfm.cpp 
	
BFM_AXI4_SVF_SRAM_OBJS=$(foreach o,$(BFM_AXI4_SVF_SRAM_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))

BFM_AXI4_SVF_SRAM_LIB=$(SOCBLOX_LIBDIR)/$(LIBPREF)axi4_svf_sram$(DLLEXT)

BFM_AXI4_SVF_SRAM_LINK=-laxi4_svf_sram

LIB_TARGETS += $(BFM_AXI4_SVF_SRAM_LIB)

