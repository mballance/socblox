
SVF_DIR=$(SOCBLOX)/svf

LIBSVF=$(SOCBLOX_LIBDIR)/core/$(LIBPREF)svf$(DLLEXT)
LIBSVF_SC=$(SOCBLOX_LIBDIR)/sc/$(LIBPREF)svf$(DLLEXT)
LIBSVF_SC_QS=$(SOCBLOX_LIBDIR)/sc_qs/$(LIBPREF)svf$(DLLEXT)
LIBSVF_DPI=$(SOCBLOX_LIBDIR)/dpi/$(LIBPREF)svf$(DLLEXT)
LIBSVF_DPI_DPI=$(SOCBLOX_LIBDIR)/dpi/$(LIBPREF)svf_dpi$(DLLEXT)
LIBSVF_HOST=$(SOCBLOX_LIBDIR)/host/$(LIBPREF)svf$(DLLEXT)
LIBSVF_LINK=-L$(SOCBLOX_LIBDIR)/core -lsvf
LIBSVF_SC_LINK=-L$(SOCBLOX_LIBDIR)/sc -lsvf
#LIBSVF_SC_QS_LINK=-L$(SOCBLOX_LIBDIR) -lsvf -lsvf_sc_qs
#LIBSVF_HOST_LINK=-L$(SOCBLOX_LIBDIR) -lsvf -lsvf_host

LIB_TARGETS += $(LIBSVF) $(LIBSVF_SC) $(LIBSVF_SC_QS) $(LIBSVF_DPI) $(LIBSVF_DPI_DPI) $(LIBSVF_HOST)

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

	
SVF_OBJS=$(foreach o,$(SVF_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))
SVF_SC_OBJS=$(foreach o,$(SVF_SC_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))
SVF_SC_QS_OBJS=$(foreach o,$(SVF_SC_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/qs/$(o))
SVF_DPI_OBJS=$(foreach o,$(SVF_DPI_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))
LIBSVF_DPI_OBJS=$(foreach o,$(LIBSVF_DPI_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))
SVF_HOST_OBJS=$(foreach o,$(SVF_HOST_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))

CXXFLAGS += -I$(SOCBLOX)/svf
CXXFLAGS += -I$(SOCBLOX)/svf/dpi
CXXFLAGS += -I$(SOCBLOX)/svf/utils


