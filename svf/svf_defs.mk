#****************************************************************************
#* 
#****************************************************************************

SVF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SVF_LIBDIR ?= .
SVF_OBJDIR ?= .
SVF_BUILD_CORE_DLL ?= 1
SVF_BUILD_SIM_WRAPPERS ?= 1
SVF_BUILD_HOST_WRAPPERS ?= 1
LIBPREF ?= lib
DLLEXT ?= .so

SRC_DIRS += $(SVF_DIR) $(SVF_DIR)/dpi $(SVF_DIR)/host $(SVF_DIR)/sc $(SVF_DIR)/utils
SRC_DIRS += $(SVF_DIR)/
# SRC_DIRS := $(SRC_DIRS) $(SVF_DIR) $(SVF_DIR)/dpi $(SVF_DIR)/host $(SVF_DIR)/sc $(SVF_DIR)/utils
# SRC_DIRS := $(SRC_DIRS) $(SVF_DIR)/

LIBSVF=$(SVF_LIBDIR)/core/$(LIBPREF)svf$(DLLEXT)
LIBSVF_AR=$(SVF_LIBDIR)/core/$(LIBPREF)svf.a
LIBSVF_SC=$(SVF_LIBDIR)/sc/$(LIBPREF)svf$(DLLEXT)
LIBSVF_SC_QS=$(SVF_LIBDIR)/sc_qs/$(LIBPREF)svf$(DLLEXT)
LIBSVF_DPI=$(SVF_LIBDIR)/dpi/$(LIBPREF)svf$(DLLEXT)
LIBSVF_DPI_DPI=$(SVF_LIBDIR)/dpi/$(LIBPREF)svf_dpi$(DLLEXT)
LIBSVF_HOST=$(SVF_LIBDIR)/host/$(LIBPREF)svf$(DLLEXT)
LIBSVF_LINK=-L$(SVF_LIBDIR)/core -lsvf
LIBSVF_SC_LINK=-L$(SVF_LIBDIR)/sc -lsvf

ifeq (1,$(SVF_BUILD_CORE_DLL))
LIB_TARGETS := $(LIB_TARGETS) $(LIBSVF)
endif

LIB_TARGETS := $(LIB_TARGETS) $(LIBSVF_AR)

ifeq (1,$(SVF_BUILD_SIM_WRAPPERS))
# LIB_TARGETS := $(LIB_TARGETS) $(LIBSVF_SC) $(LIBSVF_SC_QS) $(LIBSVF_DPI) $(LIBSVF_DPI_DPI) 
LIB_TARGETS := $(LIB_TARGETS) $(LIBSVF_SC) $(LIBSVF_DPI) $(LIBSVF_DPI_DPI) 
endif

ifeq (1,$(SVF_BUILD_HOST_WRAPPERS))
LIB_TARGETS := $(LIB_TARGETS) $(LIBSVF_HOST)
endif


SVF_SRC= \
  svf_bfm.cpp \
  svf_cmdline.cpp \
  svf_component_ctor.cpp \
  svf_component.cpp \
  svf_config_db.cpp \
  svf_factory.cpp \
  svf_object_ctor.cpp \
  svf_object.cpp \
  svf_objection.cpp \
  svf_root.cpp \
  svf_runtest.cpp \
  svf_test.cpp \
  svf_test_ctor.cpp \
  svf_thread.cpp \
  svf_thread_mutex.cpp \
  svf_thread_cond.cpp \
  \
  svf_semaphore.cpp \
  \
  svf_task_mgr_base.cpp \
  svf_task_base.cpp 
 

SVF_SC_SRC= \
	svf_thread_sc.cpp \
	svf_thread_mutex_sc.cpp \
	svf_thread_cond_sc.cpp \
	svf_cmdline_sc.cpp \
	svf_argfile_parser.cpp \
	svf_sc_api.cpp 
	
SVF_HOST_SRC= \
	svf_thread_host.cpp \
	svf_thread_mutex_host.cpp \
	svf_thread_cond_host.cpp \
	svf_cmdline_host.cpp \
	svf_argfile_parser.cpp
	
SVF_DPI_SRC= \
	svf_cmdline_dpi.cpp			\
	svf_argfile_parser.cpp		\
	svf_thread_dpi.cpp			\
	svf_thread_mutex_dpi.cpp	\
	svf_thread_cond_dpi.cpp		\
	svf_dpi_int.cpp				\
	svf_dpi.cpp

LIBSVF_DPI_SRC= \
	libsvf_dpi.cpp	

	
SVF_OBJS=$(foreach o,$(SVF_SRC:.cpp=.o),$(SVF_OBJDIR)/$(o))
SVF_SC_OBJS=$(foreach o,$(SVF_SC_SRC:.cpp=.o),$(SVF_OBJDIR)/$(o))
SVF_SC_QS_OBJS=$(foreach o,$(SVF_SC_SRC:.cpp=.o),$(SVF_OBJDIR)/qs/$(o))
SVF_DPI_OBJS=$(foreach o,$(SVF_DPI_SRC:.cpp=.o),$(SVF_OBJDIR)/$(o))
LIBSVF_DPI_OBJS=$(foreach o,$(LIBSVF_DPI_SRC:.cpp=.o),$(SVF_OBJDIR)/$(o))
SVF_HOST_OBJS=$(foreach o,$(SVF_HOST_SRC:.cpp=.o),$(SVF_OBJDIR)/$(o))

CXXFLAGS += -I$(SOCBLOX)/svf
CXXFLAGS += -I$(SOCBLOX)/svf/dpi
CXXFLAGS += -I$(SOCBLOX)/svf/utils

$(LIBSVF_AR) : $(SVF_OBJS)

$(LIBSVF) : $(SVF_OBJS)

$(LIBSVF_SC) : $(SVF_OBJS) $(SVF_SC_OBJS)

$(LIBSVF_DPI) : $(SVF_DPI_OBJS)

$(LIBSVF_SC_QS) : $(SVF_SC_QS_OBJS)

$(LIBSVF_DPI_DPI) : $(LIBSVF_DPI_OBJS)

