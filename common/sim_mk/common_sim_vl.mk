
#********************************************************************
#* Compile rules
#********************************************************************

LD_LIBRARY_PATH := $(SOCBLOX)/libs/$(PLATFORM)/sc:$(LD_LIBRARY_PATH)

CXXFLAGS += -I$(SYSTEMC)/include -I$(SOCBLOX)/svf/sc
CXXFLAGS += -I$(BUILD_DIR)/obj_dir
CXXFLAGS += -I$(VERILATOR_ROOT)/include
CXXFLAGS += -I$(VERILATOR_ROOT)/include/vltstd

ifeq (1,$(VERILATOR_TRACE_EN))
CXXFLAGS += -DVL_TRACE_EN
TRACE=--trace
endif

ifeq ($(SIMX),1)
include V$(TB).mk
endif

-include verilator.d

vlog_build : $(VERILATOR_DEPS)
	rm -rf obj_dir
	verilator $(TRACE) --sc -Wno-fatal -MMD \
		--top-module $(TOP_MODULE) \
		$(VL_VLOG_ARGS) $(VLOG_ARGS) 
	sed -e 's/^[^:]*: /VERILATOR_DEPS=/' obj_dir/V$(TB)__ver.d > verilator.d
	touch $@

build : $(LIB_TARGETS) $(EXE_TARGETS) $(TESTBENCH_OBJS) target_build vlog_build
	$(MAKE) SOCBLOX=$(SOCBLOX) TB=$(TB) SIMX=1 TESTBENCH_OBJS="$(TESTBENCH_OBJS)" \
	    VERILATOR_TRACE_EN=$(VERILATOR_TRACE_EN) BFM_LIBS="$(BFM_LIBS)" \
	    LIBSVF_LINK="$(LIBSVF_LINK)" \
	    LIBSVF_SC_LINK="$(LIBSVF_SC_LINK)" \
	    -C obj_dir -f $(COMMON_SIM_MK) \
		$(BUILD_DIR)/simx

$(BUILD_DIR)/simx : $(VK_GLOBAL_OBJS) V$(TB)__ALL.a $(BUILD_DIR)/objs/$(TB).o
	$(CXX) -o $(BUILD_DIR)/simx \
	    	$(BUILD_DIR)/objs/$(TB).o \
			$(TESTBENCH_OBJS) \
			-Wl,--whole-archive \
			V$(TB)__ALL.a \
			-Wl,--no-whole-archive \
			$(VK_GLOBAL_OBJS) \
			$(foreach l,$(filter %.so, $(BFM_LIBS)), -L$(dir $(l)) -l$(subst lib,,$(basename $(notdir $(l))))) \
			$(LIBSVF_SC_LINK) \
			$(SYSTEMC)/lib-linux/libsystemc.a -lpthread
			
$(BUILD_DIR)/objs/$(TB).o : $(SIM_DIR)/../tb/$(TB).cpp
	$(CXX) -c $(CXXFLAGS) -o $@ $^

#********************************************************************
#* Simulation settings
#********************************************************************
run : 
	$(BUILD_DIR)/simx +TESTNAME=$(TESTNAME) +TIMEOUT=$(TIMEOUT) -f sim.f

