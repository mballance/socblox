
#include "svf_thread_cond.h"

#ifdef _WIN32
#else
#include <pthread.h>
#endif

svf_thread_cond_h svf_thread_cond::create()
{
	pthread_cond_t *cond = new pthread_cond_t;

	pthread_cond_init(cond, 0);

	return cond;
}

void svf_thread_cond::destroy(svf_thread_cond_h c)
{
	pthread_cond_t *cond = static_cast<pthread_cond_t *>(c);
	pthread_cond_destroy(cond);
}

void svf_thread_cond::wait(svf_thread_cond_h c, svf_thread_mutex_h m)
{
	pthread_cond_t *cond = static_cast<pthread_cond_t *>(c);
	pthread_mutex_t *mutex = static_cast<pthread_mutex_t *>(m);

	pthread_cond_wait(cond, mutex);
}

void svf_thread_cond::notify(svf_thread_cond_h c)
{
	pthread_cond_t *cond = static_cast<pthread_cond_t *>(c);
	pthread_cond_signal(cond);
}

void svf_thread_cond::notify_all(svf_thread_cond_h c)
{
	pthread_cond_t *cond = static_cast<pthread_cond_t *>(c);
	pthread_cond_broadcast(cond);
}

