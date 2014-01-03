/*
 * svf_thread_mutex.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef SVF_THREAD_MUTEX_H_
#define SVF_THREAD_MUTEX_H_

typedef void *svf_thread_mutex_h;

class svf_thread_cond;
class svf_thread_mutex {
	friend class svf_thread_cond;

	public:
		svf_thread_mutex();

		~svf_thread_mutex();

		void lock();

		void unlock();

	private:
		static svf_thread_mutex_h create();

		static void destroy(svf_thread_mutex_h m);

		static void lock(svf_thread_mutex_h m);

		static void unlock(svf_thread_mutex_h m);

	private:
		svf_thread_mutex_h				m_mutex_h;


};

#endif /* SVF_THREAD_MUTEX_H_ */
