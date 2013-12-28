

$(LIBSVM) : $(SVM_OBJS)
	if test ! -d $(SOCBLOX_LIBDIR); then mkdir -p $(SOCBLOX_LIBDIR); fi
	$(LINK) -o $(LIBSVM) $(DLLOUT) $(SVM_OBJS)
	
$(LIBSVM_SC) : $(SVM_SC_OBJS)
	if test ! -d $(SOCBLOX_LIBDIR); then mkdir -p $(SOCBLOX_LIBDIR); fi
	$(LINK) -o $(LIBSVM_SC) $(DLLOUT) $(SVM_SC_OBJS)


$(SOCBLOX_OBJDIR)/%.o : $(SVM_DIR)/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(SVM_DIR)/$*.cpp

$(SOCBLOX_OBJDIR)/%.o : $(SVM_DIR)/sc/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(SVM_DIR)/sc/$*.cpp
	
$(SOCBLOX_OBJDIR)/%.o : $(SVM_DIR)/utils/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(SVM_DIR)/utils/$*.cpp