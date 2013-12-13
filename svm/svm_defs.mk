
SVM_DIR=$(SOCBLOX)/svm

LIBSVM=$(SOCBLOX_LIBDIR)/$(LIBPREF)svm$(DLLEXT)
LIBSVM_SC=$(SOCBLOX_LIBDIR)/$(LIBPREF)svm_sc$(DLLEXT)
LIBSVM_LINK=-L$(SOCBLOX_LIBDIR) -lsvm
LIBSVM_SC_LINK=-L$(SOCBLOX_LIBDIR) -lsvm -lsvm_sc

LIB_TARGETS += $(LIBSVM) $(LIBSVM_SC)

SVM_SRC= \
  svm_bfm.cpp \
  svm_component_ctor.cpp \
  svm_component.cpp \
  svm_factory.cpp \
  svm_object_ctor.cpp \
  svm_object.cpp \
  svm_root.cpp \
  svm_test.cpp \
  svm_thread.cpp \
  svm_thread_mutex.cpp \
  svm_thread_cond.cpp \
 

SVM_SC_SRC= \
	svm_sc_thread.cpp \
	svm_thread_mutex_sc.cpp \
	svm_thread_cond_sc.cpp
	
SVM_OBJS=$(foreach o,$(SVM_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))
SVM_SC_OBJS=$(foreach o,$(SVM_SC_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))

CXXFLAGS += -I$(SOCBLOX)/svm


