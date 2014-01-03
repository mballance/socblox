

$(SOCBLOX_LIBDIR)/$(LIBPREF)axi4_svf_bfm$(DLLEXT) : $(SVF_AXI4_BFM_OBJS) $(LIBSVF)
	if test ! -d $(SOCBLOX_LIBDIR); then mkdir -p $(SOCBLOX_LIBDIR); fi
	$(LINK) -o $@ $(DLLOUT) $(SVF_AXI4_BFM_OBJS) $(LIBSVF_LINK)

$(SOCBLOX_OBJDIR)/%.o : $(SVF_AXI4_BFM_DIR)/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(SVF_AXI4_BFM_DIR)/$*.cpp
	