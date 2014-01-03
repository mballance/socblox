/*
 * svf_argfile_parser.h
 *
 *  Created on: Dec 23, 2013
 *      Author: ballance
 */

#ifndef SVF_ARGFILE_PARSER_H_
#define SVF_ARGFILE_PARSER_H_
#include <vector>
#include <string>
#include <stack>
#include <cstdio>
#include <stdlib.h>

using namespace std;

class svf_argfile_parser {

	public:
		svf_argfile_parser();

		virtual ~svf_argfile_parser();

		int process(int argc, const char *const* argv);

		const vector<string> &cmdline() const;

	private:

		int process_file(
				const string		&basedir,
				bool				process_rel,
				const string		&file);

		string expand(const string &path);

		bool next_tok(string &tok);

		int get_ch();

		void unget_ch(int ch);

	private:
		int							m_unget_ch;
		FILE						*m_fp;
		vector<string>				m_args;
};

#endif /* SVF_ARGFILE_PARSER_H_ */
