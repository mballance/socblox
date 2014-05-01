
A23_DUALCORE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

VLOG_FILELISTS += $(A23_DUALCORE)/a23_dualcore.F

else

endif
