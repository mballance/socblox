/*
 * svm_elf_loader.cpp
 *
 *  Created on: Dec 21, 2013
 *      Author: ballance
 */

#include "svm_elf_loader.h"

svm_elf_loader::svm_elf_loader(svm_mem_if *mem_if) : m_mem_if(mem_if) {
}

svm_elf_loader::~svm_elf_loader() {
	// TODO Auto-generated destructor stub
}

int svm_elf_loader::load(const char *filename)
{
	FILE *fp;
	ElfHeader hdr;
	Elf32_Phdr phdr;
	Elf32_Shdr shdr;

	fp = fopen(filename, "r");

	if (!fp) {
		return -1;
	}

	fread(&hdr, sizeof(ElfHeader), 1, fp);

	if (hdr.e_ident[1] != 'E' ||
			hdr.e_ident[2] != 'L' ||
			hdr.e_ident[3] != 'F') {
		return -1;
	}

	if (hdr.e_machine != 40) {
		return -1;
	}

	for (int i=0; i<hdr.e_shnum; i++) {
		fseek(fp, hdr.e_shoff+hdr.e_shentsize*i, 0);

		fread(&shdr, sizeof(Elf32_Shdr), 1, fp);

		fprintf(stdout, "sh_type=0x%08x size=0x%08x flags=0x%08x\n",
				shdr.sh_type, shdr.sh_size, shdr.sh_flags);

		if (shdr.sh_type == SHT_PROGBITS && shdr.sh_size != 0 &&
			(shdr.sh_flags & SHF_ALLOC) != 0) {
			// read in data
			uint8_t *tmp = new uint8_t[shdr.sh_size];
			uint32_t data;
			fprintf(stdout, "Loading %d bytes @ 0x%08x..0x%08x\n",
					shdr.sh_size, shdr.sh_addr, (shdr.sh_addr+shdr.sh_size));

			fseek(fp, shdr.sh_offset, 0);
			fread(tmp, shdr.sh_size, 1, fp);

			// Copy data to memory
			for (int j=0; j<shdr.sh_size; j+=4) {
				data = tmp[j];
				data |= (tmp[j+1] << 8);
				data |= (tmp[j+2] << 16);
				data |= (tmp[j+3] << 24);

				m_mem_if->write32(shdr.sh_addr+j, data);

				if (j+4 >= shdr.sh_size) {
					fprintf(stdout, "Load last addr=0x%08x\n", shdr.sh_addr+j);
				}
			}

			delete [] tmp;
		}

		if (shdr.sh_type == SHT_NOBITS && shdr.sh_size != 0) {
			fprintf(stdout, "Fill %0d bytes @ 0x%08x..0x%08x\n",
					shdr.sh_size, shdr.sh_addr, (shdr.sh_addr+shdr.sh_size));
			for (int j=0; j<shdr.sh_size; j+=4) {
				m_mem_if->write32(shdr.sh_addr+j, 0);

				if (j+4 >= shdr.sh_size) {
					fprintf(stdout, "Fill last addr='h%08h", shdr.sh_addr+j);
				}
			}
		}
	}

	fclose(fp);

	return 0;
}


