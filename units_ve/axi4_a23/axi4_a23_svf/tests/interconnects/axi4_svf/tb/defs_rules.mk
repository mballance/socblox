
ifeq (,$(RULES))

AXI4_2X2_TB_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

AXI4_2X2_TB_SRC=\
	axi4_interconnect_env.cpp 
	
TESTBENCH_OBJS += $(foreach o,$(AXI4_2X2_TB_SRC:.cpp=.o),$(BUILD_DIR)/objs/$(o))

CXXFLAGS += -I$(AXI4_2X2_TB_DIR)

else

$(BUILD_DIR)/objs/%.o : $(AXI4_2X2_TB_DIR)/%.cpp
	if test ! -d $(BUILD_DIR)/objs; then mkdir -p $(BUILD_DIR)/objs; fi
	$(CXX) -c $(CXXFLAGS) -o $@ $^

endif