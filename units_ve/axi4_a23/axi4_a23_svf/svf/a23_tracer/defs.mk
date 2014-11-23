
A23_TRACER_DIR=$(AXI4_AMBER23_SVF)/svf/a23_tracer
A23_TRACER_LIB=$(BUILD_DIR)/libs/liba23_tracer.so
A23_TRACER_LINK=-L$(BUILD_DIR)/libs -la23_tracer

# LIB_TARGETS += $(A23_TRACER_LIB)


CXXFLAGS += -I$(A23_TRACER_DIR)

A23_TRACER_SRC=\
	a23_tracer.cpp \
	a23_tracer_dpi_mgr.cpp
	
A23_TRACER_OBJ=$(foreach o, $(A23_TRACER_SRC:.cpp=.o),$(BUILD_DIR)/objs/$(o))	

A23_TESTBENCH_OBJS += $(A23_TRACER_OBJ)