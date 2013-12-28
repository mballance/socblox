
$(BUILD_DIR)/objs/%.o : $(A23_SVM_TESTS_DIR)/%.cpp
	if test ! -d $(BUILD_DIR)/objs; then mkdir -p $(BUILD_DIR)/objs; fi
	$(CXX) -c $(CXXFLAGS) -o $@ $^
	
		