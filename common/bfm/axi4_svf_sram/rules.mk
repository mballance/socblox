

$(BFM_AXI4_SVF_SRAM_LIB) : $(BFM_AXI4_SVF_SRAM_OBJS) $(LIBSVF)
	if test ! -d $(SOCBLOX_LIBDIR); then mkdir -p $(SOCBLOX_LIBDIR); fi
	$(LINK) -o $@ $(DLLOUT) $(BFM_AXI4_SVF_SRAM_OBJS) 

$(SOCBLOX_OBJDIR)/%.o : $(BFM_AXI4_SVF_SRAM_DIR)/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(BFM_AXI4_SVF_SRAM_DIR)/$*.cpp

	