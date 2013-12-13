

$(SOCBLOX_LIBDIR)/$(LIBPREF)svm_axi4_bfm$(DLLEXT) : $(SVM_AXI4_BFM_OBJS) $(LIBSVM)
	if test ! -d $(SOCBLOX_LIBDIR); then mkdir -p $(SOCBLOX_LIBDIR); fi
	$(LINK) -o $@ $(DLLOUT) $(SVM_AXI4_BFM_OBJS) $(LIBSVM_LINK)

$(SOCBLOX_OBJDIR)/%.o : $(SVM_AXI4_BFM_DIR)/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(SVM_AXI4_BFM_DIR)/$*.cpp
	