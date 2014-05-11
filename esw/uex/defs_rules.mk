
ESW_UEX_DIR := $(dir $(lastword $(MAKEFILE_LIST)))


ifneq (1,$(RULES))

SRC_DIRS += $(ESW_UEX_DIR)

else


endif
