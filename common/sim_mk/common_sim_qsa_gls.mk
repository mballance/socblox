
#********************************************************************
#* Compile rules
#********************************************************************
#SVF_BUILD_SIM_WRAPPERS := 0
LIB_TARGETS += $(BUILD_DIR)/libs/tb_dpi.so

LD_LIBRARY_PATH := $(shell echo $(SVF_LIBDIR)/dpi:$(BUILD_DIR)/libs:$(LD_LIBRARY_PATH) | sed -e 's% %%g')
export LD_LIBRARY_PATH
CXXFLAGS += -I$(QUESTA_HOME)/include -I$(QUESTA_HOME)/include/systemc

DPI_LIBS += $(SVF_LIBDIR)/dpi/libsvf_dpi
DPI_LIBS += $(BUILD_DIR)/libs/tb_dpi

ifneq (,$(MODELSIM_ASE))
# Set path so we use the compiler with Modelsim
PATH := $(MODELSIM_ASE)/bin:$(MODELSIM_ASE)/gcc-4.5.0-linux/bin:$(PATH)
export PATH
endif

ifeq ($(DEBUG),true)
	TOP=$(TOP_MODULE)_dbg
	DOFILE_COMMANDS += "log -r /\*;"
else
	TOP=$(TOP_MODULE)_opt
endif

SYNTH_DEPS = $(foreach unit,$(notdir $(SYNTH_UNITS)),$(BUILD_DIR)/$(unit).synth)

vpath %_synth.mk $(foreach unit,$(SYNTH_UNITS),$(unit)/synth/scripts)

$(BUILD_DIR)/%.synth : %_synth.mk
	echo "BUILD UNIT: $^"
	if test ! -d $(BUILD_DIR)/$(basename $(notdir $(firstword $^))); then mkdir -p $(BUILD_DIR)/$(basename $(notdir $(firstword $^))); fi
	$(MAKE) -C $(BUILD_DIR)/$(basename $(notdir $(firstword $^))) -f $(firstword $^) sim
	
$(SYNTH_DEPS) : target_build

vlog_build : $(SYNTH_DEPS)
	echo "SYNTH_UNITS=$(SYNTH_UNITS)"
	echo "DEPS=$(SYNTH_DEPS)"
	rm -rf work
	vlib work
	vlog -sv \
		$(QS_VLOG_ARGS) \
		$(VLOG_ARGS)

build : vlog_build $(EXE_TARGETS) $(LIB_TARGETS) $(TESTBENCH_OBJS) target_build

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
	echo "onbreak {puts "ONBREAK"}" >> run.do
	echo "run $(TIMEOUT)" >> run.do
	echo "quit -f" >> run.do
	vmap work ${BUILD_DIR}/work
	echo "BUILD_DIR=$(BUILD_DIR)"
	echo "LD_LIBRARY_PATH=$(LD_LIBRARY_PATH)"
	vsim -c -do run.do -voptargs="+acc+$(TOP_MODULE)+3 -debugdb" $(TOP_MODULE) \
		+TESTNAME=$(TESTNAME) -f sim.f \
		$(foreach dpi,$(DPI_LIBS),-sv_lib $(dpi))

