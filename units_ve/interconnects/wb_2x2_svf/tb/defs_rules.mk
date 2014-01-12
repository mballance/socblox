
ifeq (,$(RULES))

TB_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SRC_DIRS += $(TB_DIR)

TB_SRC= \
 wb_2x2_env.cpp

TESTBENCH_OBJS += $(foreach o, $(TB_SRC:.cpp=.o),$(BUILD_DIR)/objs/$(o))

else

endif