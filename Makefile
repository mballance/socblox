
SOCBLOX := $(shell pwd)

include $(SOCBLOX)/common/common_defs.mk
include $(SOCBLOX)/common/bfm/axi4_svm/svm_axi4_bfm_defs.mk
include $(SOCBLOX)/svm/svm_defs.mk

all : inc_targets lib_targets

lib_targets : $(LIB_TARGETS)


inc_targets : $(INC_TARGETS)

clean :
	rm -rf $(SOCBLOX_LIBDIR) $(SOCBLOX_OBJDIR) inc_targets lib_targets
#	rm -rf $(CLEAN_LIST)

include $(SOCBLOX)/svm/svm_rules.mk
include $(SOCBLOX)/common/common_rules.mk
include $(SOCBLOX)/common/bfm/axi4_svm/svm_axi4_bfm_rules.mk
