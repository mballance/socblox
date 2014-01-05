

$(LIBSVF) : $(SVF_OBJS)
	if test ! -d $(SOCBLOX_LIBDIR); then mkdir -p $(SOCBLOX_LIBDIR); fi
	$(LINK) -o $(LIBSVF) $(DLLOUT) $(SVF_OBJS)
	
$(LIBSVF_SC) : $(SVF_SC_OBJS)
	if test ! -d $(SOCBLOX_LIBDIR); then mkdir -p $(SOCBLOX_LIBDIR); fi
	$(LINK) -o $(LIBSVF_SC) $(DLLOUT) $(SVF_SC_OBJS)
	
$(LIBSVF_HOST) : $(SVF_HOST_OBJS)
	if test ! -d $(SOCBLOX_LIBDIR); then mkdir -p $(SOCBLOX_LIBDIR); fi
	$(LINK) -o $(LIBSVF_HOST) $(DLLOUT) $(SVF_HOST_OBJS)


$(SOCBLOX_OBJDIR)/%.o : $(SVF_DIR)/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(SVF_DIR)/$*.cpp

$(SOCBLOX_OBJDIR)/%.o : $(SVF_DIR)/sc/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(SVF_DIR)/sc/$*.cpp
	
$(SOCBLOX_OBJDIR)/%.o : $(SVF_DIR)/host/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(SVF_DIR)/host/$*.cpp
	
$(SOCBLOX_OBJDIR)/%.o : $(SVF_DIR)/utils/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(SVF_DIR)/utils/$*.cpp