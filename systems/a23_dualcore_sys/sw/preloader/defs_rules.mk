
A23_DUALCORE_SYS_PRELOADER_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

A23_DUALCORE_SYS_PRELOADER_ELF := preloader/a23_preloader.elf

# include $(SOCBLOX)/units/wb_uart/sw/defs_rules.mk
# include $(SOCBLOX)/units/bidi_message_queue/sw/defs_rules.mk

ifneq (1,$(RULES))

SRC_DIRS += $(A23_DUALCORE_SYS_PRELOADER_DIR)

else

#	$(SVF_OBJDIR)/a23_startup_multicore.o \
#	$(SVF_OBJDIR)/io_stubs.o \
#	$(SVF_OBJDIR)/a23_cpp_support.o \
#	$(SVF_OBJDIR)/a23_memory.o \
#	$(SVF_LIBDIR)/libbidi_message_queue_drv.a

preloader/%.elf : preloader/%.o \
	$(SVF_OBJDIR)/a23_preloader_crt0.o \
	$(SVF_OBJDIR)/io_stubs.o \
	$(SVF_OBJDIR)/uex_thread_primitives.o \
	$(SVF_OBJDIR)/a23_cpp_support.o \
	$(SVF_OBJDIR)/a23_memory.o \
	$(SVF_LIBDIR)/libbidi_message_queue_drv.a \
	$(PRELOADER_SLIB)
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(LD) -o $@ \
		-T $(A23_DUALCORE_SYS_PRELOADER_DIR)/a23_preloader.lds $^ \
		$(LIBC) $(LIBGCC) $(LIBCXX)
	
endif
