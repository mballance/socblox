/*
 * svm_argfile_parser.h
 *
 *  Created on: Dec 23, 2013
 *      Author: ballance
 */

#ifndef SVM_ARGFILE_PARSER_H_
#define SVM_ARGFILE_PARSER_H_
#include <vector>
#include <string>
#include <stack>
#include <cstdio>
#include <stdlib.h>

using namespace std;

class svm_argfile_parser {

	public:
		svm_argfile_parser();

		virtual ~svm_argfile_parser();

		int process(int argc, char **argv);

	private:
		class InData {

			private:
				FILE			*m_fp;
				int				 m_unget_ch;

			public:
				InData(FILE *fp) : m_fp(fp), m_unget_ch(-1) {}

				int get_ch();

				void unget_ch(int ch);

		};

	private:

		int process_file(
				const string		&basedir,
				bool				process_rel,
				const string		&file);

		int getch();

		void unget(int ch);

		string expand(const string &path);

		bool next_tok(string &tok);

	private:
		FILE						*m_fp;
		vector<string>				m_args;
		int							m_argc;
		char						**m_argv;
};

#endif /* SVM_ARGFILE_PARSER_H_ */
