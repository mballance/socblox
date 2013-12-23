

$(COMMON_SVM_LIB) : $(COMMON_SVM_OBJS) $(LIBSVM)
	if test ! -d $(SOCBLOX_LIBDIR); then mkdir -p $(SOCBLOX_LIBDIR); fi
	$(LINK) -o $@ $(DLLOUT) $(COMMON_SVM_OBJS) $(LIBSVM_LINK)

$(SOCBLOX_OBJDIR)/%.o : $(COMMON_SVM_DIR)/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $(SOCBLOX_OBJDIR)/$*.o $(CXXFLAGS) $(COMMON_SVM_DIR)/$*.cpp

	