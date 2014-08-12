
ifneq (1,$(RULES))

else

%.qpf : %.f
	quartus_sh -t $(COMMON_RTL)/../scripts/quartus_utils.tcl \
		$*.f

%.map : %.qpf
	quartus_map $(subst .qpf,,$(*))
	touch $@
	
%.fit : %.map
	quartus_fit $(subst .map,,$(*))
	touch $@
	
%.sim : %.fit
	quartus_eda $(subst .fit,,$(*)) \
		--simulation --tool=modelsim --format=verilog 
	touch $@
	
%.sta : %.fit	
	quartus_sta $(subst .fit,,$(*))
	touch $@
	
%.asm : %.fit	
	quartus_asm $(subst .fit,,$(*))
	touch $@
	
endif