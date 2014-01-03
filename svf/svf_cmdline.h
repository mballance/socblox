/*
 * svf_cmdline.h
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#ifndef SVF_CMDLINE_H_
#define SVF_CMDLINE_H_
#include <string>
#include <vector>

using namespace std;

class svf_cmdline {

	public:

		svf_cmdline();

		virtual ~svf_cmdline();

		static svf_cmdline &get_default();

		bool valueplusarg(const char *pattern, string &value);

	protected:



	private:

		static vector<string> args();

	private:
		vector<string>				m_args;
		static svf_cmdline			*m_default;
};

#endif /* SVF_CMDLINE_H_ */
