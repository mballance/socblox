/*
 * svf_argfile_parser.cpp
 *
 *  Created on: Dec 23, 2013
 *      Author: ballance
 */

#include "svf_argfile_parser.h"
#include <string.h>

svf_argfile_parser::svf_argfile_parser() : m_unget_ch(-1) {
	// TODO Auto-generated constructor stub

}

int svf_argfile_parser::process(int argc, const char * const* argv)
{
	for (int i=0; i<argc; i++) {
		if (!strcmp(argv[i], "-f")) {
			i++;
			process_file("", false, argv[i]);
			/*
		} else if (!strcmp(argv[i], "-F")) {
			process_file("", false, argv[i]);
			 */
		} else {
			m_args.push_back(argv[i]);
		}
	}

	return 0;
}

const vector<string> &svf_argfile_parser::cmdline() const
{
	return m_args;
}

svf_argfile_parser::~svf_argfile_parser() {
	// TODO Auto-generated destructor stub
}

int svf_argfile_parser::process_file(
		const string		&basedir,
		bool				process_rel,
		const string		&file)
{
	FILE *fp = fopen(file.c_str(), "r");

	if (!fp && process_rel) {
		string full = process_rel + "/" + file;

		fp = fopen(full.c_str(), "r");

		if (!fp) {
			fprintf(stdout, "ERROR: Failed to open argument file %s or %s\n",
					file.c_str(), full.c_str());
			return 0;
		}
	} else if (!fp) {
		fprintf(stdout, "ERROR: Failed to open argument file %s\n", file.c_str());
		return 0;
	}

	FILE *ex_fp = m_fp;
	int ex_unget_ch = m_unget_ch;
	string tok, tok2;
	m_fp = fp;
	m_unget_ch = -1;

	while (next_tok(tok)) {

		if (tok == "-f") {
			next_tok(tok2); // path

			tok2 = expand(tok2);

			process_file(basedir, false, tok2);
		} else {
			m_args.push_back(expand(tok));
		}
	}


	m_fp = ex_fp;
	m_unget_ch = ex_unget_ch;

	return 1;
}

string svf_argfile_parser::expand(const string &path)
{
	string ret;

	for (int i=0; i<path.size(); i++) {
		int ch = path.at(i);
		if (ch == '$') {
			int start = i;
			int end = -1;

			if (i+2 < path.size() && path.at(i+1) == '{') {

				for (int j=i+2; j<path.size(); j++) {
					if (path.at(j) == '}') {
						end = j;
						break;
					}
				}
			}

			if (end != -1) {
				string key = path.substr(start+2, (end-start-2));
				const char *value = getenv(key.c_str());

				if (value) {
					ret.append(value);
					i = end;
				} else {
					ret.push_back((char)ch);
				}
			} else {
				ret.push_back((char)ch);
			}
		} else {
			ret.push_back((char)ch);
		}
	}

	return ret;
}

bool svf_argfile_parser::next_tok(string &tok)
{
	bool ret = false;
	int ch;
	tok.clear();

	ch = get_ch();

	// Skip whitespace and comments
	while (ch != -1 && (isspace(ch) || ch == '/')) {
		if (ch == '/') {
			int ch2 = get_ch();
			if (ch2 == '*') {
				// multi-line comment
				ch = -1;
				ch2 = -1;

				while ((ch = get_ch()) != -1) {
					if (ch2 == '*' && ch == '/') {
						break;
					}
					ch2 = ch;
				}

				if (ch != -1) {
					ch = get_ch();
				}
			} else if (ch2 == '/') {
				// single-line comment
				while ((ch = get_ch()) != -1 && ch != '\n') { }
			} else {
				// Nothing
				unget_ch(ch2);
				break;
			}
		} else {
			ch = get_ch();
		}
	}

	// Read in token
	if (ch == '"') {
		// quoted string
		ret = true;
		int last_ch = -1;

		while ((ch = get_ch()) != -1 && ch != '"' && last_ch != '\\') {
			tok.push_back((char)ch);
			last_ch = ch;
		}
	} else if (ch != -1) {
		ret = true;

		tok.push_back((char)ch);

		while ((ch = get_ch()) != -1 && !isspace(ch)) {
			tok.push_back((char)ch);
		}

		// give back the whitespace
		unget_ch(ch);
	}

	return ret;
}

int svf_argfile_parser::get_ch()
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

void svf_argfile_parser::unget_ch(int ch)
{
	m_unget_ch = ch;
}
