
# SVF_AXI4_BFM_DIR=$(SOCBLOX)/common/bfm/axi4_svf
SVF_AXI4_BFM_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SVF_AXI4_BFM_SRC=\
	axi4_master_bfm.cpp \
	axi4_master_bfm_dpi_mgr.cpp 
	
CXXFLAGS += -I$(SVF_AXI4_BFM_DIR)
	
SVF_AXI4_BFM_OBJS=$(foreach o,$(SVF_AXI4_BFM_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))

LIB_TARGETS += $(SOCBLOX_LIBDIR)/libaxi4_svf_bfm$(DLLEXT)

AXI4_SVF_BFM_LINK=-L$(SOCBLOX_LIBDIR) -laxi4_svf_bfm
