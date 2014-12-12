
ifeq (,$(RULES)) 

STIM_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

STIM_SRC = $(notdir $(wildcard $(STIM_DIR)/*.cpp))

TESTBENCH_OBJS += $(foreach o, $(STIM_SRC:.cpp=.o),$(BUILD_DIR)/objs/$(o))

SRC_DIRS += $(STIM_DIR)

else
endif