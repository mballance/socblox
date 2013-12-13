/*
 * svm_thread_mutex.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef SVM_THREAD_MUTEX_H_
#define SVM_THREAD_MUTEX_H_

typedef void *svm_thread_mutex_h;

class svm_thread_cond;
class svm_thread_mutex {
	friend class svm_thread_cond;

	public:
		svm_thread_mutex();

		~svm_thread_mutex();

		void lock();

		void unlock();

	private:
		static svm_thread_mutex_h create();

		static void destroy(svm_thread_mutex_h m);

		static void lock(svm_thread_mutex_h m);

		static void unlock(svm_thread_mutex_h m);

	private:
		svm_thread_mutex_h				m_mutex_h;


};

#endif /* SVM_THREAD_MUTEX_H_ */
