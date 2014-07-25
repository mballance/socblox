/*
 * svf_ptr_vector.h
 *
 *  Created on: Jul 24, 2014
 *      Author: ballance
 */

#ifndef SVF_PTR_VECTOR_H_
#define SVF_PTR_VECTOR_H_
#include <stdint.h>

class svf_ptr_vector_base {
	public:
		svf_ptr_vector_base();

		virtual ~svf_ptr_vector_base();

		uint32_t size() const { return m_size; }

	protected:

		void append_int(void *it);

	protected:

		uint32_t		m_size;
		uint32_t		m_limit;
		uint32_t		m_incr;
		void			**m_store;

	private:

};

template <class T> class svf_ptr_vector : public svf_ptr_vector_base {

	public:

		svf_ptr_vector() {}

		virtual ~svf_ptr_vector() { };

		inline T *at(uint32_t idx) const { return static_cast<T *>(m_store[idx]); }

		inline void append(T *it) { append_int(it); }

		inline void push_back(T *it) { append_int(it); }

	private:
};

#endif /* SVF_PTR_VECTOR_H_ */
