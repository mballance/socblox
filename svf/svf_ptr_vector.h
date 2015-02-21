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

		void set_size(uint32_t sz);

	protected:

		void append_int(void *it);

		void remove_int(uint32_t idx);

		void remove_int(void *it);

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

		inline void set(uint32_t idx, T *it) const { m_store[idx] = it; }

		inline void append(T *it) { append_int(it); }

		inline void push_back(T *it) { append_int(it); }

		inline T *pop_back() {
			T *ret = (m_size>0)?static_cast<T *>(m_store[m_size-1]):0;
			m_size--;
			return ret;
		}

		inline void remove(uint32_t idx) { remove_int(idx); }

		inline void remove(T *it) { remove_int(it); }

	private:
};

#endif /* SVF_PTR_VECTOR_H_ */
