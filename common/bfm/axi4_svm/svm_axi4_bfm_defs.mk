
SVM_AXI4_BFM_DIR=$(SOCBLOX)/common/bfm/axi4_svm

SVM_AXI4_BFM_SRC=\
	axi4_master_bfm.cpp \
	axi4_master_bfm_dpi_mgr.cpp 
	
SVM_AXI4_BFM_OBJS=$(foreach o,$(SVM_AXI4_BFM_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))

LIB_TARGETS += $(SOCBLOX_LIBDIR)/libsvm_axi4_bfm$(DLLEXT)
