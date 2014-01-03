/*
 * svf_elf_loader.h
 *
 *  Created on: Dec 21, 2013
 *      Author: ballance
 */

#ifndef SVF_ELF_LOADER_H_
#define SVF_ELF_LOADER_H_
#include "svf_mem_if.h"
#include <map>

using namespace std;

class svf_elf_loader {
	static const int	SHT_NULL			= 0;	/* sh_type */
	static const int	SHT_PROGBITS		= 1;
	static const int	SHT_SYMTAB			= 2;
	static const int	SHT_STRTAB			= 3;
	static const int	SHT_RELA			= 4;
	static const int	SHT_HASH			= 5;
	static const int	SHT_DYNAMIC			= 6;
	static const int	SHT_NOTE			= 7;
	static const int	SHT_NOBITS			= 8;
	static const int	SHT_REL				= 9;
	static const int	SHT_SHLIB			= 10;
	static const int	SHT_DYNSYM			= 11;
	static const int	SHT_UNKNOWN12		= 12;
	static const int	SHT_UNKNOWN13		= 13;
	static const int	SHT_INIT_ARRAY		= 14;
	static const int	SHT_FINI_ARRAY		= 15;
	static const int	SHT_PREINIT_ARRAY	= 16;
	static const int	SHT_GROUP			= 17;
	static const int	SHT_SYMTAB_SHNDX	= 18;
	static const int	SHT_NUM				= 19;

	static const int SHF_WRITE =          (1 << 0);     /* Writable */
	static const int SHF_ALLOC =          (1 << 1);     /* Occupies memory during execution */
	static const int SHF_EXECINSTR =      (1 << 2);     /* Executable */
	static const int SHF_MERGE     =      (1 << 4);     /* Might be merged */
	static const int SHF_STRINGS   =      (1 << 5);     /* Contains nul-terminated strings */
	static const int SHF_INFO_LINK =      (1 << 6);     /* `sh_info' contains SHT index */
	static const int SHF_LINK_ORDER =     (1 << 7);     /* Preserve order after combining */
	static const int SHF_OS_NONCONFORMING = (1 << 8);   /* Non-standard OS specific handling
                                           required */
	static const int SHF_GROUP           =  (1 << 9);   /* Section is member of a group.  */
	static const int SHF_TLS             =  (1 << 10);  /* Section hold thread-local data.  */
	static const int SHF_MASKOS          =  0x0ff00000; /* OS-specific.  */
	static const int SHF_MASKPROC        =  0xf0000000; /* Processor-specific */
	static const int SHF_ORDERED         =  (1 << 30);  /* Special ordering requirement
                                           (Solaris).  */
	static const int SHF_EXCLUDE         =  (1 << 31);  /* Section is excluded unless
                                           referenced or allocated (Solaris).
                                           referenced or allocated (Solaris).
                                           */


	static const int ElfHeader_SZ  = 52;
	static const int Elf32_Phdr_SZ = 32;
	static const int Elf32_Shdr_SZ = 40;

	static const int EI_NIDENT  = 16;

	typedef struct {
		uint8_t  	e_ident[EI_NIDENT]; /* bytes 0 to 15  */
		uint16_t 	e_e_type;           /* bytes 15 to 16 */
		uint16_t 	e_machine;          /* bytes 17 to 18 */
		uint32_t	e_version;          /* bytes 19 to 22 */
		uint32_t	e_entry;            /* bytes 23 to 26 */
		uint32_t	e_phoff;            /* bytes 27 to 30 */
		uint32_t	e_shoff;            /* bytes 31 to 34 */
		uint32_t	e_flags;            /* bytes 35 to 38 */
		uint16_t	e_ehsize;           /* bytes 39 to 40 */
		uint16_t 	e_phentsize;        /* bytes 41 to 42 */
		uint16_t 	e_phnum;            /* bytes 43 to 44 (2B to 2C) */
		uint16_t 	e_shentsize;        /* bytes 45 to 46 */
		uint16_t 	e_shnum;            /* bytes 47 to 48 */
		uint16_t 	e_shstrndx;         /* bytes 49 to 50 */
	} ElfHeader;

	/* Program Headers */
	typedef struct {
		uint32_t p_type;     /* entry type */
		uint32_t p_offset;   /* file offset */
		uint32_t p_vaddr;    /* virtual address */
		uint32_t p_paddr;    /* physical address */
		uint32_t p_filesz;   /* file size */
		uint32_t p_memsz;    /* memory size */
		uint32_t p_flags;    /* entry flags */
		uint32_t p_align;    /* memory/file alignment */
	} Elf32_Phdr;


	/* Section Headers */
	typedef struct {
		uint32_t sh_name;        /* section name - index into string table */
		uint32_t sh_type;        /* SHT_... */
		uint32_t sh_flags;       /* SHF_... */
		uint32_t sh_addr;        /* virtual address */
		uint32_t sh_offset;      /* file offset */
		uint32_t sh_size;        /* section size */
		uint32_t sh_link;        /* misc info */
		uint32_t sh_info;        /* misc info */
		uint32_t sh_addralign;   /* memory alignment */
		uint32_t sh_entsize;     /* entry size if table */
	} Elf32_Shdr;

	typedef struct {
	    uint32_t	st_name;
	    uint32_t	st_value;
	    uint32_t	st_size;
	    uint8_t		st_info;
	    uint8_t		st_other;
	    uint16_t	st_shndx;
	} Elf32_Sym;

	public:

		svf_elf_loader(svf_mem_if *mem_if);

		virtual ~svf_elf_loader();

		int load(const char *path);

	private:

	private:
		svf_mem_if					*m_mem_if;
		map<string, uint32_t>		m_symtab;
};

#endif /* SVF_ELF_LOADER_H_ */
