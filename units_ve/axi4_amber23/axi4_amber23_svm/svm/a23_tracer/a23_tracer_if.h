/*
 * a23_tracer_if.h
 *
 *  Created on: Dec 24, 2013
 *      Author: ballance
 */

#ifndef A23_TRACER_IF_H_
#define A23_TRACER_IF_H_
#include <stdint.h>

class a23_tracer_if {
	public:

		virtual ~a23_tracer_if() {}

		virtual void mem_access(
				uint32_t			addr,
				bool				is_write,
				uint32_t			data) = 0;

		virtual void execute(
				uint32_t			addr,
				uint32_t			op
				) = 0;

};



#endif /* A23_TRACER_IF_H_ */
