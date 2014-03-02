
ifeq (,$(RULES))

TB_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SRC_DIRS += $(TB_DIR)

TB_SRC = $(filter-out $(notdir $(wildcard $(TB_DIR)/*_tb.cpp)), $(notdir $(wildcard $(TB_DIR)/*.cpp)))
# TB_SRC = $(notdir $(wildcard $(TB_DIR)/*.cpp))

TESTBENCH_OBJS += $(foreach o, $(TB_SRC:.cpp=.o),$(BUILD_DIR)/objs/$(o))

else

endif