
ESW_A23_BOOT_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

SRC_DIRS += $(ESW_A23_BOOT_DIR)

else


endif
