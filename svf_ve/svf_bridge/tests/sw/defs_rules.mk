
TESTS_SW_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SOCBLOX)/units/wb_uart/sw/defs_rules.mk

ifneq (1,$(RULES))

else

endif
