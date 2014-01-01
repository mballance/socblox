
ifeq (,$(RULES))

AXI4_2X2_TESTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

AXI4_2X2_TESTS_SRC=\
	axi4_interconnect_test_base.cpp \
	axi4_interconnect_basic_rw_test.cpp
	
	
AXI4_2X2_TESTS_OBJ=$(foreach o,$(AXI4_2X2_TESTS_SRC:.cpp=.o),$(BUILD_DIR)/objs/$(o))

TESTBENCH_OBJS += $(AXI4_2X2_TESTS_OBJ)

CXXFLAGS += -I$(AXI4_2X2_TESTS_DIR)

else # Rules portion

$(BUILD_DIR)/objs/%.o : $(AXI4_2X2_TESTS_DIR)/%.cpp
	if test ! -d $(BUILD_DIR)/objs; then mkdir -p $(BUILD_DIR)/objs; fi
	$(CXX) -c $(CXXFLAGS) -o $@ $^

endif