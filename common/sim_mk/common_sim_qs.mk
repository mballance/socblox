
#********************************************************************
#* Compile rules
#********************************************************************
#SVF_BUILD_SIM_WRAPPERS := 0
LIB_TARGETS += $(BUILD_DIR)/libs/tb_dpi.so

LD_LIBRARY_PATH := $(SVF_LIBDIR)/dpi:$(LD_LIBRARY_PATH)
export LD_LIBRARY_PATH
CXXFLAGS += -I$(QUESTA_HOME)/include -I$(QUESTA_HOME)/include/systemc

DPI_LIBS += $(SVF_LIBDIR)/dpi/libsvf_dpi
DPI_LIBS += $(BUILD_DIR)/libs/tb_dpi

ifeq ($(DEBUG),true)
	TOP=$(TOP_MODULE)_dbg
	DOFILE_COMMANDS += "log -r /\*;"
else
	TOP=$(TOP_MODULE)_opt
endif

build : vlog_build $(LIB_TARGETS) $(TESTBENCH_OBJS) target_build

.phony: vopt vopt_opt vopt_dbg vopt_compile
vlog_build : vopt

vopt : vopt_opt vopt_dbg

vopt_opt : vopt_compile
	vopt -o $(TB)_opt $(TB)

vopt_dbg : vopt_compile
	vopt +acc -o $(TB)_dbg $(TB)

vopt_compile :
	rm -rf work
	vlib work
	vlog -sv \
		$(QS_VLOG_ARGS) \
		$(VLOG_ARGS)

$(BUILD_DIR)/libs/tb_dpi.so : $(TESTBENCH_OBJS) $(BFM_LIBS) $(LIBSVF)
	if test ! -d $(BUILD_DIR)/libs; then mkdir -p $(BUILD_DIR)/libs; fi
	$(CXX) -o $@ -shared $(filter %.o, $^) \
		$(foreach l,$(filter %.so, $^), -L$(dir $(l)) -l$(subst lib,,$(basename $(notdir $(l))))) \
		$(LIBSVF_LINK)
		
#********************************************************************
#* Simulation settings
#********************************************************************
#ifeq ($(DEBUG),true)
#	TOP:=$(TOP_MODULE)_dbg
#	DOFILE_COMMANDS += "log -r /*;"
#else
#	TOP:=$(TOP_MODULE)_opt
#endif

run :
	echo $(DOFILE_COMMANDS) > run.do
	echo "run $(TIMEOUT); quit -f" >> run.do
	vmap work ${BUILD_DIR}/work
	vsim -c -do run.do $(TOP) \
		+TESTNAME=$(TESTNAME) -f sim.f \
		$(foreach dpi,$(DPI_LIBS),-sv_lib $(dpi))

