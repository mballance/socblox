/*
 * svf_cmdline.h
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#ifndef SVF_CMDLINE_H_
#define SVF_CMDLINE_H_
#include "svf_string.h"
#include "svf_ptr_vector.h"
#include <stdint.h>

using namespace std;

class svf_cmdline {

	public:

		svf_cmdline();

		virtual ~svf_cmdline();

		static svf_cmdline &get_default();

		bool valueplusarg(const char *pattern, svf_string &value);

	protected:



	private:

		static svf_ptr_vector<svf_string> args();

	private:
		svf_ptr_vector<svf_string>	 m_args;
		static svf_cmdline			*m_default;
};

#endif /* SVF_CMDLINE_H_ */
