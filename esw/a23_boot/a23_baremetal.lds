OUTPUT_FORMAT("elf32-littlearm", "elf32-bitarm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)

MEMORY {
	ROM(rx)		: ORIGIN = 0x00000000, LENGTH = 1M
	RAM(rwx)	: ORIGIN = 0x20000000, LENGTH = 1M
/*
	GBL(rwx)	: ORIGIN = 0x30000000, LENGTH = 16k
	ROM(rx)		: ORIGIN = 0x00010000, LENGTH = 64k
	RAM(rwx)	: ORIGIN = 0x00020000, LENGTH = 16k
	GBL(rwx)	: ORIGIN = 0x00030000, LENGTH = 16k
 */
}

C_STACK_SIZE = 4096;
IRQ_STACK_SIZE = 128;
FIQ_STACK_SIZE = 128;
SVC_STACK_SIZE = 128;
ABT_STACK_SIZE = 128;
UND_STACK_SIZE = 128;
MAX_N_CORES = 16;
MBOX_SIZE = 16;

SECTIONS {
	.reset : {
		*a23_startup.o (.text)
		. = ALIGN(0x4);
	} > ROM
	
	.ramvect : {
		__ram_start = .;
		. = 0x40;
	} > RAM
	
	.text : {
		CREATE_OBJECT_SYMBOLS
		*(.text .text.* .gnu.linkonce.t.*)
		*(.plt)
		*(.gnu.warning)
		*(.glue_7t) *(.glue_7)
		
		. = ALIGN(0x4);
		
		/* Static constructor / destructors */
		KEEP (*crtbegin.o(.ctors))
		KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
		KEEP (*(SORT(.ctors.*)))
		KEEP (*crtend.o(.ctors))
		KEEP (*crtbegin.o(.dtors))
		KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
		KEEP (*(SORT(.dtors.*)))
		KEEP (*crtend.o(.dtors))
	
		*(.rodata .rodata.* .gnu.linkonce.r.*)
		
		*(.init)
		*(.fini)
	} >ROM

	.init_array : {
		__init_array_start = .;	
		_init = .;
		*(.init_array)
	} >ROM
	__init_array_end = .;
	
	.ARM.exidx : {
		__exidx_start = .;
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)
		__exidx_end = .;
	} >ROM
	_etext = .;
	
	.data : {
		__data_load = LOADADDR(.data);
		__data_start = .;
		KEEP(*(.jcr))
		*(.got.plt) *(.got)
		*(.shdata)
		*(.data .data.* .gnu.linkonce.d.*)
		. = ALIGN(4);
		_edata = .;
	} >RAM AT>ROM
	
	.bss : {
		__bss_start__ = .;
		*(.shbss)
		*(.bss .bss.* .gnu.linkonce.b.*)
		*(COMMON)
		. = ALIGN(4);
		__bss_end__ = .;
	} >RAM
	
	.start : {
	/*
		_end = . ;
		__end = _end;
		PROVIDE(end = .);
	 */
		__heap_start = .;
		. += 4k;
		__heap_end = .;
		
		__stack_start__ = . ;
		__irq_stack0_start__ = .;
		. += IRQ_STACK_SIZE;
		. = ALIGN(4);
		__irq_stack0_top__ = .;
		. += (IRQ_STACK_SIZE * (MAX_N_CORES - 1));
		. = ALIGN(4);
		__irq_stack_top__ = . ;

		. += FIQ_STACK_SIZE;
		. = ALIGN(4);
		__fiq_stack_top__ = . ;
	
		__svc_stack0_start__ = .;	
		. += SVC_STACK_SIZE;
		. = ALIGN(4);
		__svc_stack0_top__ = .;	
		. += (SVC_STACK_SIZE * (MAX_N_CORES - 1));
		. = ALIGN(4);
		__svc_stack_top__ = . ;
		
		. += ABT_STACK_SIZE;
		. = ALIGN(4);
		__abt_stack_top__ = . ;
		
		. += UND_STACK_SIZE;
		. = ALIGN(4);
		__und_stack_top__ = . ;
		
		. += C_STACK_SIZE;
		. = ALIGN(4);
		__c_stack_top__ = . ;
		
		__stack_end__ = . ;
	} >RAM

/*	
	.shared : {
		__mailbox_start = .;
		. += (MBOX_SIZE * MAX_N_CORES);
		. = ALIGN(4);
		__mailbox_end = .;
	} > GBL
 */
	
	
	.stab 0 (NOLOAD) : {
		*(.stab)
	}
	
	.stabstr 0 (NOLOAD) : {
		*(.stabstr)
	}
	
	.debug			0 : { *(.debug) }
	.line			0 : { *(.line) }
}
	
