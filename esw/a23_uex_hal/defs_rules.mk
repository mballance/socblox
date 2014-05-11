
ESW_A23_UEX_HAL_DIR := $(dir $(lastword $(MAKEFILE_LIST)))


ifneq (1,$(RULES))

SRC_DIRS += $(ESW_A23_UEX_HAL_DIR)

else


endif
