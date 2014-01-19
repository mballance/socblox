

$(LIBSVF) : $(SVF_OBJS)
	echo "MAKE LIBSVF"
	if test ! -d $(SOCBLOX_LIBDIR)/core; then mkdir -p $(SOCBLOX_LIBDIR)/core; fi
	$(LINK) -o $(LIBSVF) $(DLLOUT) $(SVF_OBJS)
	
$(LIBSVF_SC) : $(SVF_OBJS) $(SVF_SC_OBJS)
	if test ! -d $(SOCBLOX_LIBDIR)/sc; then mkdir -p $(SOCBLOX_LIBDIR)/sc; fi
	$(LINK) -o $(LIBSVF_SC) $(DLLOUT) $(SVF_OBJS) $(SVF_SC_OBJS)
	
$(LIBSVF_SC_QS) : $(SVF_OBJS) $(SVF_SC_QS_OBJS)
	if test ! -d $(SOCBLOX_LIBDIR)/sc_qs; then mkdir -p $(SOCBLOX_LIBDIR)/sc_qs; fi
	$(LINK) -o $(LIBSVF_SC_QS) $(DLLOUT) $(SVF_OBJS) $(SVF_SC_QS_OBJS)
	
$(LIBSVF_DPI) : $(SVF_OBJS) $(SVF_DPI_OBJS)
	if test ! -d $(SOCBLOX_LIBDIR)/dpi; then mkdir -p $(SOCBLOX_LIBDIR)/dpi; fi
	$(LINK) -o $(LIBSVF_DPI) $(DLLOUT) $(SVF_OBJS) $(SVF_DPI_OBJS)
	
$(LIBSVF_DPI_DPI) : $(SVF_OBJS) $(LIBSVF_DPI_OBJS) $(LIBSVF_DPI)
	if test ! -d $(SOCBLOX_LIBDIR)/dpi; then mkdir -p $(SOCBLOX_LIBDIR)/dpi; fi
	$(LINK) -o $@ $(DLLOUT) $(SVF_OBJS) $(LIBSVF_DPI_OBJS) -L$(SOCBLOX_LIBDIR)/dpi -lsvf
	
$(LIBSVF_HOST) : $(SVF_OBJS) $(SVF_HOST_OBJS)
	if test ! -d $(SOCBLOX_LIBDIR)/host; then mkdir -p $(SOCBLOX_LIBDIR)/host; fi
	$(LINK) -o $(LIBSVF_HOST) $(DLLOUT) $(SVF_OBJS) $(SVF_HOST_OBJS)
	
$(LIBSVF_A23) : $(SVF_A23_OBJS)	


$(SOCBLOX_OBJDIR)/%.o : $(SVF_DIR)/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(SVF_DIR)/$*.cpp

$(SOCBLOX_OBJDIR)/%.o : $(SVF_DIR)/sc/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -I$(SYSTEMC)/include -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(SVF_DIR)/sc/$*.cpp
	
$(SOCBLOX_OBJDIR)/%.o : $(SVF_DIR)/dpi/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -I$(SYSTEMC)/include -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(SVF_DIR)/dpi/$*.cpp
	
$(SOCBLOX_OBJDIR)/qs/%.o : $(SVF_DIR)/sc/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR)/qs; then mkdir -p $(SOCBLOX_OBJDIR)/qs; fi
	$(QUESTA_HOME)/gcc-4.5.0-linux/bin/g++ -Di386 -c -I$(QUESTA_HOME)/include -I$(QUESTA_HOME)/include/systemc -o $(SOCBLOX_OBJDIR)/qs/$*.o $(CXXFLAGS) $(SVF_DIR)/sc/$*.cpp
	
$(SOCBLOX_OBJDIR)/qs/%.o : $(SVF_DIR)/utils/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR)/qs; then mkdir -p $(SOCBLOX_OBJDIR)/qs; fi
	$(QUESTA_HOME)/gcc-4.5.0-linux/bin/g++ -Di386 -c -I$(QUESTA_HOME)/include -I$(QUESTA_HOME)/include/systemc -o $(SOCBLOX_OBJDIR)/qs/$*.o $(CXXFLAGS) $(SVF_DIR)/utils/$*.cpp
	
$(SOCBLOX_OBJDIR)/%.o : $(SVF_DIR)/host/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(SVF_DIR)/host/$*.cpp
	
$(SOCBLOX_OBJDIR)/%.o : $(SVF_DIR)/utils/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(SVF_DIR)/utils/$*.cpp
	