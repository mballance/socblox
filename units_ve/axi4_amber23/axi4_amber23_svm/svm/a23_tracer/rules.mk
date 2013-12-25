
$(A23_TRACER_LIB) : $(A23_TRACER_OBJ)
	if test ! -d $(BUILD_DIR)/libs; then mkdir -p $(BUILD_DIR)/libs; fi
	$(LINK) -o $@ $(DLLOUT) $(A23_TRACER_OBJ)

$(BUILD_DIR)/objs/%.o : $(A23_TRACER_DIR)/%.cpp
	if test ! -d $(BUILD_DIR)/objs; then mkdir -p $(BUILD_DIR)/objs; fi
	$(CXX) -c $(CXXFLAGS) -o $@ $^