#****************************************************************************
#* 
#****************************************************************************

SVF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SVF_LIBDIR ?= .
SVF_OBJDIR ?= .
SVF_BUILD_CORE_DLL ?= 1
SVF_BUILD_SIM_WRAPPERS ?= 1
SVF_BUILD_SIM_SC_WRAPPER ?= 1
SVF_BUILD_HOST_WRAPPERS ?= 1
SVF_BUILD_UTH_WRAPPERS ?= 0
LIBPREF ?= lib
DLLEXT ?= .so


SRC_DIRS += $(SVF_DIR) $(SVF_DIR)/dpi $(SVF_DIR)/host $(SVF_DIR)/sc $(SVF_DIR)/utils
SRC_DIRS += $(SVF_DIR)/uth
SRC_DIRS += $(SVF_DIR)/stub
SRC_DIRS += $(SVF_DIR)/
# SRC_DIRS := $(SRC_DIRS) $(SVF_DIR) $(SVF_DIR)/dpi $(SVF_DIR)/host $(SVF_DIR)/sc $(SVF_DIR)/utils
# SRC_DIRS := $(SRC_DIRS) $(SVF_DIR)/

LIBSVF_DL:=$(SVF_LIBDIR)/core/$(LIBPREF)svf$(DLLEXT)
LIBSVF_AR:=$(SVF_LIBDIR)/core/$(LIBPREF)svf.a
LIBSVF_STUB:=$(SVF_LIBDIR)/stub/$(LIBPREF)svf_impl$(DLLEXT)
LIBSVF_SC_DL:=$(SVF_LIBDIR)/sc/$(LIBPREF)svf_impl$(DLLEXT)
LIBSVF_SC_AR:=$(SVF_LIBDIR)/sc/$(LIBPREF)svf.a
LIBSVF_SC_QS=$(SVF_LIBDIR)/sc_qs/$(LIBPREF)svf_impl$(DLLEXT)
LIBSVF_DPI=$(SVF_LIBDIR)/dpi/$(LIBPREF)svf_impl$(DLLEXT)
LIBSVF_DPI_AR=$(SVF_LIBDIR)/dpi/$(LIBPREF)svf.a
LIBSVF_DPI_DPI_AR=$(SVF_LIBDIR)/dpi/$(LIBPREF)svf_dpi.a
LIBSVF_HOST=$(SVF_LIBDIR)/host/$(LIBPREF)svf_impl$(DLLEXT)
LIBSVF_UTH=$(SVF_LIBDIR)/uth/$(LIBPREF)svf_impl$(DLLEXT)
LIBSVF_UTH_AR=$(SVF_LIBDIR)/uth/$(LIBPREF)svf.a

ifeq (true,$(DYNLINK))
LIBSVF=$(LIBSVF_DL)
LIBSVF_SC=$(LIBSVF_SC_DL)
LIBSVF_LINK=-L$(SVF_LIBDIR)/core -lsvf -L$(SVF_LIBDIR)/stub -lsvf_impl
LIBSVF_SC_LINK=-L$(SVF_LIBDIR)/sc -lsvf
LIBSVF_STUB_LINK=-L$(SVF_LIBDIR)/stub -lsvf_impl
else
LIBSVF=$(LIBSVF_AR)
LIBSVF_SC=$(LIBSVF_SC_AR)
LIBSVF_SC_LINK=$(LIBSVF_AR) $(LIBSVF_SC_AR)
endif


# ifeq (1,$(SVF_BUILD_CORE_DLL))
# LIB_TARGETS := $(LIB_TARGETS) 
# MSB: $(LIBSVF)
# endif

LIB_TARGETS := $(LIB_TARGETS) $(LIBSVF) $(LIBSVF_STUB)

ifeq (1,$(SVF_BUILD_SIM_WRAPPERS))
# LIB_TARGETS := $(LIB_TARGETS) $(LIBSVF_SC) $(LIBSVF_SC_QS) $(LIBSVF_DPI) $(LIBSVF_DPI_DPI) 
ifeq (1,$(SVF_BUILD_SIM_SC_WRAPPER))
ifeq (true,$(DYNLINK))
LIB_TARGETS := $(LIB_TARGETS) $(LIBSVF_SC) 
else
LIB_TARGETS := $(LIB_TARGETS) $(LIBSVF_SC_AR) 
endif
endif

ifeq (true,$(DYNLINK))
LIB_TARGETS := $(LIB_TARGETS) $(LIBSVF_DPI) $(LIBSVF_DPI_DPI) 
else
LIB_TARGETS := $(LIB_TARGETS) $(LIBSVF_DPI_AR) $(LIBSVF_DPI_DPI_AR) 
endif
endif

ifeq (1,$(SVF_BUILD_HOST_WRAPPERS))
LIB_TARGETS := $(LIB_TARGETS) $(LIBSVF_HOST)
endif

ifeq (1,$(SVF_BUILD_UTH_WRAPPERS))
LIB_TARGETS := $(LIB_TARGETS) $(LIBSVF_UTH_AR)
endif


SVF_SRC= \
  svf_string.cpp \
  svf_string_map.cpp \
  svf_ptr_vector.cpp \
  svf_cmdline.cpp \
  svf_component_ctor.cpp \
  svf_component.cpp \
  svf_config_db.cpp \
  svf_factory.cpp \
  svf_log_handle.cpp \
  svf_log_msg.cpp \
  svf_log_server.cpp \
  svf_msg_def.cpp \
  svf_stdio_msg_renderer.cpp \
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
  svf_task_base.cpp \
  \
  svf_bridge.cpp 				\
  svf_bridge_socket.cpp 		\
  svf_bridge_msg.cpp			\
  svf_bridge_log_msg.cpp		\
  svf_bridge_log_renderer.cpp	\
  svf_bridge_log_connector.cpp
  
 

SVF_SC_SRC= \
	svf_thread_sc.cpp \
	svf_thread_mutex_sc.cpp \
	svf_thread_cond_sc.cpp \
	svf_cmdline_sc.cpp \
	svf_argfile_parser.cpp \
	svf_sc_api.cpp 
	
SVF_STUB_SRC= \
	svf_stub.cpp 
	
SVF_HOST_SRC= \
	svf_thread_host.cpp \
	svf_thread_mutex_host.cpp \
	svf_thread_cond_host.cpp \
	svf_cmdline_host.cpp \
	svf_argfile_parser.cpp
	
SVF_UTH_SRC= \
	svf_thread_uth.cpp \
	
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
SVF_STUB_OBJS=$(foreach o,$(SVF_STUB_SRC:.cpp=.o),$(SVF_OBJDIR)/$(o))
SVF_SC_QS_OBJS=$(foreach o,$(SVF_SC_SRC:.cpp=.o),$(SVF_OBJDIR)/qs/$(o))
SVF_DPI_OBJS=$(foreach o,$(SVF_DPI_SRC:.cpp=.o),$(SVF_OBJDIR)/$(o))
LIBSVF_DPI_OBJS=$(foreach o,$(LIBSVF_DPI_SRC:.cpp=.o),$(SVF_OBJDIR)/$(o))
SVF_HOST_OBJS=$(foreach o,$(SVF_HOST_SRC:.cpp=.o),$(SVF_OBJDIR)/$(o))
SVF_UTH_OBJS=$(foreach o,$(SVF_UTH_SRC:.cpp=.o),$(SVF_OBJDIR)/$(o))

CXXFLAGS += -I$(SOCBLOX)/svf
CXXFLAGS += -I$(SOCBLOX)/svf/dpi
CXXFLAGS += -I$(SOCBLOX)/svf/utils

$(LIBSVF_AR) : $(SVF_OBJS)

$(LIBSVF_DL) : $(SVF_OBJS) $(LIBSVF_STUB)

$(LIBSVF_SC_AR) : $(SVF_SC_OBJS)

$(LIBSVF_SC_DL) : $(SVF_OBJS) $(SVF_SC_OBJS)

$(LIBSVF_STUB) : $(SVF_STUB_OBJS)

$(LIBSVF_DPI) : $(SVF_OBJS) $(SVF_DPI_OBJS)

$(LIBSVF_SC_QS) : $(SVF_SC_QS_OBJS)

$(LIBSVF_DPI_DPI) : $(LIBSVF_DPI_OBJS) $(LIBSVF_DPI)

$(LIBSVF_UTH_AR) : $(SVF_OBJS) $(SVF_UTH_OBJS)


