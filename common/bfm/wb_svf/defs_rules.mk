
WB_SVF_BFM_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifeq (,$(RULES))

CXXFLAGS += -I$(WB_SVF_BFM_DIR)

WB_SVF_MASTER_BFM_SRC = \
	wb_master_bfm.cpp \
	wb_master_bfm_dpi_mgr.cpp
	
WB_SVF_MASTER_BFM_OBJS=$(foreach o,$(WB_SVF_MASTER_BFM_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))
	
WB_SVF_MASTER_BFM_LIB=$(SOCBLOX_LIBDIR)/libwb_svf_master_bfm$(DLLEXT)

LIB_TARGETS += $(WB_SVF_MASTER_BFM_LIB)

WB_SVF_MASTER_BFM_LINK=-L$(SOCBLOX_LIBDIR) -lwb_svf_master_bfm	

else

$(SOCBLOX_LIBDIR)/libwb_svf_master_bfm$(DLLEXT) : $(WB_SVF_MASTER_BFM_OBJS) $(LIBSVF)
	echo "REMAKE $(LIBSVF)"
	if test -d $(SOCBLOX_LIBDIR); then mkdir -p $(SOCBLOX_LIBDIR); fi
	$(LINK) -o $@ $(DLLOUT) $(WB_SVF_MASTER_BFM_OBJS) $(LIBSVF_LINK)
	
$(SOCBLOX_OBJDIR)/%.o : $(WB_SVF_BFM_DIR)/%.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c -o $@ $(CXXFLAGS) $^



endif