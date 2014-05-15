
#********************************************************************
#* Compile rules
#********************************************************************

LD_LIBRARY_PATH := $(SVF_LIBDIR)/sc:$(LD_LIBRARY_PATH)

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

#VL_DEBUG_FLAGS=
#VL_DEBUG_FLAGS=--debug
#VL_DEBUG_FLAGS=--debug --gdbbt

vlog_build : $(VERILATOR_DEPS)
	rm -rf obj_dir
	verilator $(TRACE) --sc -Wno-fatal -MMD $(VL_DEBUG_FLAGS) \
		--top-module $(TOP_MODULE) \
		$(VL_VLOG_ARGS) $(VLOG_ARGS) 
	sed -e 's/^[^:]*: /VERILATOR_DEPS=/' obj_dir/V$(TB)__ver.d > verilator.d
	touch $@

build : simx_build $(EXE_TARGETS) target_build
		
simx_build : vlog_build $(LIB_TARGETS) $(TESTBENCH_OBJS) 	
	$(MAKE) SOCBLOX=$(SOCBLOX) TB=$(TB) SIMX=1 TESTBENCH_OBJS="$(TESTBENCH_OBJS)" \
	    VERILATOR_TRACE_EN=$(VERILATOR_TRACE_EN) BFM_LIBS="$(BFM_LIBS)" \
	    LIBSVF_LINK="$(LIBSVF_LINK)" \
	    LIBSVF_SC_LINK="$(LIBSVF_SC_LINK)" \
	    -C obj_dir -f $(COMMON_SIM_MK) \
		$(BUILD_DIR)/simx
	touch $@

$(BUILD_DIR)/simx : $(VK_GLOBAL_OBJS) V$(TB)__ALL.a $(TESTBENCH_OBJS) $(BUILD_DIR)/objs/$(TB).o
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
run : $(SIM_DATAFILES)
	$(BUILD_DIR)/simx +TESTNAME=$(TESTNAME) +TIMEOUT=$(TIMEOUT) -f sim.f -trace -tracefile vlt_dump.fst

