
A23_DUALCORE_SYS_PRELOADER_APP_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))
SRC_DIRS += $(A23_DUALCORE_SYS_PRELOADER_APP_DIR)
else

endif

