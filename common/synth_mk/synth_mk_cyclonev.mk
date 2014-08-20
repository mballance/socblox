
ifneq (1,$(RULES))

else

sim : $(TOP_MODULE).qpf $(TOP_MODULE).map $(TOP_MODULE).fit $(TOP_MODULE).sim

img : $(TOP_MODULE).qpf $(TOP_MODULE).map $(TOP_MODULE).fit $(TOP_MODULE).asm

#		-f $(SCRIPTS_DIR)/$(TOP_MODULE)_altera.f \

%.qpf : %.f $(TOP_MODULE)_altera.f
	quartus_sh -t $(COMMON_RTL)/../scripts/quartus_utils.tcl \
		-project $(TOP_MODULE) \
		-top $(TOP_MODULE) \
		+define+FPGA \
		$(SCRIPTS_DIR)/$(TOP_MODULE).sdc \
		-f $(COMMON_DIR)/fpga/altera_sockit_settings.f \
		$(foreach f,$^,-f $(f))

%.map : %.qpf $(MEM_FILE)
	if test "x$(MEM_FILE)" != "x"; then \
		cp $(MEM_FILE) $(ROM_FILE) ; \
	fi
	quartus_map $(subst .qpf,,$(*))
	touch $@
	
%.fit : %.map
	quartus_fit $(subst .map,,$(*))
	touch $@
	
%.sim : %.fit
	quartus_eda $(subst .fit,,$(*)) \
		--simulation --tool=modelsim --format=verilog --gen_script=on
	touch $@
	
%.sta : %.fit	
	quartus_sta $(subst .fit,,$(*))
	touch $@
	
%.asm : %.fit	
	quartus_asm $(subst .fit,,$(*))
	touch $@
	
endif