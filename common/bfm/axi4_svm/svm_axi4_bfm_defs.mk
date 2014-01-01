
# SVM_AXI4_BFM_DIR=$(SOCBLOX)/common/bfm/axi4_svm
SVM_AXI4_BFM_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SVM_AXI4_BFM_SRC=\
	axi4_master_bfm.cpp \
	axi4_master_bfm_dpi_mgr.cpp 
	
CXXFLAGS += -I$(SVM_AXI4_BFM_DIR)
	
SVM_AXI4_BFM_OBJS=$(foreach o,$(SVM_AXI4_BFM_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))

LIB_TARGETS += $(SOCBLOX_LIBDIR)/libaxi4_svm_bfm$(DLLEXT)

AXI4_SVM_BFM_LINK=-L$(SOCBLOX_LIBDIR) -laxi4_svm_bfm
