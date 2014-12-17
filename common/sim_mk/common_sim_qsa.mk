
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

ifneq (,$(QUESTA_HOME))
# Set path so we use the compiler with Modelsim
PATH := $(QUESTA_HOME)/bin:$(QUESTA_HOME)/gcc-4.5.0-linux/bin:$(PATH)
export PATH
else
ifneq (,$(MODELSIM_ASE))
# Set path so we use the compiler with Modelsim
PATH := $(MODELSIM_ASE)/bin:$(MODELSIM_ASE)/gcc-4.5.0-linux/bin:$(PATH)
export PATH
endif
endif

ifeq ($(DEBUG),true)
	TOP=$(TOP_MODULE)_dbg
	DOFILE_COMMANDS += "log -r /\*;"
else
	TOP=$(TOP_MODULE)_opt
endif

vlog_build : 
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
	echo "run $(TIMEOUT); quit -f" >> run.do
	vmap work ${BUILD_DIR}/work
	vsim -c -do run.do -voptargs="+acc -xprop,mode=pass" $(TOP_MODULE) \
		+TESTNAME=$(TESTNAME) -f sim.f \
		$(foreach dpi,$(DPI_LIBS),-sv_lib $(dpi))

