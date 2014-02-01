
ifeq (,$(RULES))

TESTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

TESTS_SRC = $(notdir $(wildcard $(TESTS_DIR)/*.cpp))

TESTBENCH_OBJS += $(foreach o, $(TESTS_SRC:.cpp=.o),$(BUILD_DIR)/objs/$(o))

SRC_DIRS += $(TESTS_DIR)

else

endif