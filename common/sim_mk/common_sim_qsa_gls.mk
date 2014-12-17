
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

ifneq (,$(QUESTA_HOME))
# Set path so we use the compiler with Modelsim
PATH := $(QUESTA_HOME)/bin:$(QUESTA_HOME)/gcc-4.5.0-linux/bin:$(PATH)
export PATH
FULL_QUESTA := 1
else
FULL_QUESTA := 0
ifneq (,$(MODELSIM_ASE))
# Set path so we use the compiler with Modelsim
PATH := $(MODELSIM_ASE)/bin:$(MODELSIM_ASE)/gcc-4.5.0-linux/bin:$(PATH)
export PATH
else
endif
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
	if test $(FULL_QUESTA) -eq 1; then \
		vopt $(TOP_MODULE) +designfile -o $(TOP_MODULE)_opt ; \
	fi

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
	echo "FULL_QUESTA=$(FULL_QUESTA) SIM_TOP=$(SIM_TOP)"
	echo $(DOFILE_COMMANDS) > run.do
	echo "onbreak {puts "ONBREAK"}" >> run.do
	echo "run $(TIMEOUT)" >> run.do
	echo "quit -f" >> run.do
	vmap work ${BUILD_DIR}/work
	echo "BUILD_DIR=$(BUILD_DIR)"
	echo "LD_LIBRARY_PATH=$(LD_LIBRARY_PATH)"
	if test $(FULL_QUESTA) -eq 1; then \
	vsim -c -do run.do $(TOP_MODULE)_opt -qwavedb=+signal \
		+TESTNAME=$(TESTNAME) -f sim.f \
		$(foreach dpi,$(DPI_LIBS),-sv_lib $(dpi)); \
	else \
	vsim -c -do run.do $(TOP_MODULE) \
		+TESTNAME=$(TESTNAME) -f sim.f \
		$(foreach dpi,$(DPI_LIBS),-sv_lib $(dpi)); \
	fi

