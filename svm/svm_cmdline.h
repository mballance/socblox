/*
 * svm_cmdline.h
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#ifndef SVM_CMDLINE_H_
#define SVM_CMDLINE_H_
#include <string>
#include <vector>

using namespace std;

class svm_cmdline {

	public:

		svm_cmdline();

		virtual ~svm_cmdline();

		static svm_cmdline &get_default();

		bool valueplusarg(const char *pattern, string &value);

	protected:



	private:

		static int argc();

		static const char * const*argv();

	private:
		vector<string>				m_args;
		static svm_cmdline			*m_default;
};

#endif /* SVM_CMDLINE_H_ */
