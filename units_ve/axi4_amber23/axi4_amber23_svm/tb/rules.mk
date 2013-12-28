
$(BUILD_DIR)/objs/%.o : $(AXI4_A23_TB_DIR)/%.cpp
	if test ! -d $(BUILD_DIR)/objs; then mkdir -p $(BUILD_DIR)/objs; fi
	$(CXX) -c $(CXXFLAGS) -o $@ $^
	
