
A23_SVM_TESTS_DIR=$(AXI4_AMBER23_SVM)/tests

A23_SVM_TESTS_SRC=\
	axi4_a23_svm_test_base.cpp \
	axi4_a23_svm_coretest.cpp
	
A23_SVM_TESTS_OBJ=$(foreach o,$(A23_SVM_TESTS_SRC:.cpp=.o),$(BUILD_DIR)/objs/$(o))

A23_TESTBENCH_OBJS += $(A23_SVM_TESTS_OBJ)

CXXFLAGS += -I$(A23_SVM_TESTS_DIR)

	