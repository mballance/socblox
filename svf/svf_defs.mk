
SVF_DIR=$(SOCBLOX)/svf

LIBSVF=$(SOCBLOX_LIBDIR)/$(LIBPREF)svf$(DLLEXT)
LIBSVF_SC=$(SOCBLOX_LIBDIR)/$(LIBPREF)svf_sc$(DLLEXT)
LIBSVF_LINK=-L$(SOCBLOX_LIBDIR) -lsvf
LIBSVF_SC_LINK=-L$(SOCBLOX_LIBDIR) -lsvf -lsvf_sc

LIB_TARGETS += $(LIBSVF) $(LIBSVF_SC)

SVF_SRC= \
  svf_bfm.cpp \
  svf_cmdline.cpp \
  svf_component_ctor.cpp \
  svf_component.cpp \
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
  svf_semaphore.cpp
 

SVF_SC_SRC= \
	svf_thread_sc.cpp \
	svf_thread_mutex_sc.cpp \
	svf_thread_cond_sc.cpp \
	svf_cmdline_sc.cpp \
	svf_argfile_parser.cpp
	
SVF_OBJS=$(foreach o,$(SVF_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))
SVF_SC_OBJS=$(foreach o,$(SVF_SC_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))

CXXFLAGS += -I$(SOCBLOX)/svf
CXXFLAGS += -I$(SOCBLOX)/svf/dpi
CXXFLAGS += -I$(SOCBLOX)/svf/utils


