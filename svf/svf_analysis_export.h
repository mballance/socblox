/*
 * svf_analysis_export.h
 *
 *  Created on: Oct 23, 2014
 *      Author: ballance
 */

#ifndef SVF_ANALYSIS_EXPORT_H_
#define SVF_ANALYSIS_EXPORT_H_

template <class T> class svf_analysis_export {

	public:

		virtual ~svf_analysis_export() { }

		virtual void write(T &t) = 0;

};



#endif /* SVF_ANALYSIS_EXPORT_H_ */
