#include "svf_cmdline.h"
#include "svf_thread_cond.h"
#include "svf_thread_mutex.h"
#include "svf_thread.h"
#include <string>
#include <vector>

using namespace std;

svf_ptr_vector<svf_string> svf_cmdline::args()
{
	svf_ptr_vector<svf_string> ret;
	return ret;
}

svf_thread_cond_h svf_thread_cond::create() { return 0; }

void svf_thread_cond::destroy(svf_thread_cond_h c) { }

void svf_thread_cond::wait(svf_thread_cond_h c, svf_thread_mutex_h m) { }

void svf_thread_cond::notify(svf_thread_cond_h c) { }

void svf_thread_cond::notify_all(svf_thread_cond_h c) { }

svf_thread_mutex_h svf_thread_mutex::create() { return 0; }

void svf_thread_mutex::destroy(svf_thread_mutex_h m) { }

void svf_thread_mutex::lock(svf_thread_mutex_h m) { }

void svf_thread_mutex::unlock(svf_thread_mutex_h m) { }

svf_native_thread_h svf_thread::create_thread(svf_closure_base *closure)
{
	return reinterpret_cast<svf_native_thread_h>(0);
}

void svf_thread::yield_thread() { }

