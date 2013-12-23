/*
 * svm_argfile_parser.cpp
 *
 *  Created on: Dec 23, 2013
 *      Author: ballance
 */

#include "svm_argfile_parser.h"

svm_argfile_parser::svm_argfile_parser() {
	// TODO Auto-generated constructor stub

}

int svm_argfile_parser::process(int argc, char **argv)
{
	for (int i=0; i<argc; i++) {
		if (!strcmp(argv[i], "-f")) {
			process_file("", false, argv[i]);
		} else if (!strcmp(argv[i], "-F")) {

		} else {
			m_args.push_back(argv[i]);
		}
	}
}

svm_argfile_parser::~svm_argfile_parser() {
	// TODO Auto-generated destructor stub
}

int svm_argfile_parser::process_file(
		const string		&basedir,
		bool				process_rel,
		const string		&file)
{
	FILE *fp = fopen(file.c_str(), "r");

	if (!fp && process_rel) {
		string full = process_rel + '/' + file;

		fp = fopen(full.c_str(), "r");

		if (!fp) {
			fprintf(stdout, "ERROR: Failed to open argument file %s\n", full.c_str());
			return 0;
		}
	} else {
		fprintf(stdout, "ERROR: Failed to open argument file %s\n", file.c_str());
		return 0;
	}

	FILE *ex_fp = m_fp;
	string tok, tok2;
	m_fp = fp;

	while (next_tok(tok)) {
		if (tok == "-f") {

		} else if (tok == "-F") {

		}
	}


	m_fp = ex_fp;

	return 1;
}

int svm_argfile_parser::InData::get_ch()
{
	int ch = -1;

	if (m_unget_ch != -1) {
		ch = m_unget_ch;
		m_unget_ch = -1;
	} else {
		ch = fgetc(m_fp);
	}

	return ch;
}

void svm_argfile_parser::InData::unget_ch(int ch)
{
	m_unget_ch = ch;
}
