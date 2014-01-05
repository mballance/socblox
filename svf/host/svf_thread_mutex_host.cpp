/*
 * svf_thread_mutex_sc.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */
#include "svf_thread_mutex.h"

#ifdef _WIN32
#else
#include <pthread.h>
#endif

svf_thread_mutex_h svf_thread_mutex::create()
{
	pthread_mutex_t *mutex = new pthread_mutex_t;

	pthread_mutex_init(mutex, 0);

	return mutex;
}

void svf_thread_mutex::destroy(svf_thread_mutex_h m)
{
	pthread_mutex_t *mutex = static_cast<pthread_mutex_t *>(m);

	pthread_mutex_destroy(mutex);
}

void svf_thread_mutex::lock(svf_thread_mutex_h m)
{
	pthread_mutex_t *mutex = static_cast<pthread_mutex_t *>(m);
	pthread_mutex_lock(mutex);
}

void svf_thread_mutex::unlock(svf_thread_mutex_h m)
{
	pthread_mutex_t *mutex = static_cast<pthread_mutex_t *>(m);
	pthread_mutex_unlock(mutex);
}



