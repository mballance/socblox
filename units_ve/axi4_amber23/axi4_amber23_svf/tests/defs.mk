
A23_SVF_TESTS_DIR=$(AXI4_AMBER23_SVF)/tests

A23_SVF_TESTS_SRC=\
	axi4_a23_svf_test_base.cpp \
	axi4_a23_svf_coretest.cpp
	
A23_SVF_TESTS_OBJ=$(foreach o,$(A23_SVF_TESTS_SRC:.cpp=.o),$(BUILD_DIR)/objs/$(o))

A23_TESTBENCH_OBJS += $(A23_SVF_TESTS_OBJ)

CXXFLAGS += -I$(A23_SVF_TESTS_DIR)

	