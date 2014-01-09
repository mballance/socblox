/*
 * libsvf_dpi.cpp
 *
 *  Created on: Jan 7, 2014
 *      Author: ballance
 */

#include "svf.h"
#include "svf_dpi_int.h"
#include "svdpi.h"
#include <stdio.h>

static svScope			svf_dpi_scope;

extern "C" void svf_dpi_create_thread(void *ud, uint32_t *tid);
extern "C" uint32_t svf_dpi_create_mutex();
extern "C" void svf_dpi_mutex_lock(uint32_t mutex_id);
extern "C" void svf_dpi_mutex_unlock(uint32_t mutex_id);
extern "C" uint32_t svf_dpi_create_cond();
extern "C" void svf_dpi_cond_wait(uint32_t cond_id, uint32_t mutex_id);
extern "C" void svf_dpi_cond_notify(uint32_t cond_id);
extern "C" void svf_dpi_cond_notify_all(uint32_t cond_id);
extern "C" void svf_dpi_thread_yield();

static void svf_dpi_create_thread_w(void *ud, uint32_t *tid)
{
	svSetScope(svf_dpi_scope);
	svf_dpi_create_thread(ud, tid);
}

static uint32_t svf_dpi_create_mutex_w()
{
	svSetScope(svf_dpi_scope);
	return svf_dpi_create_mutex();
}

static void svf_dpi_mutex_lock_w(uint32_t mutex_id)
{
	svSetScope(svf_dpi_scope);
	svf_dpi_mutex_lock(mutex_id);
}

static void svf_dpi_mutex_unlock_w(uint32_t mutex_id)
{
	svSetScope(svf_dpi_scope);
	svf_dpi_mutex_unlock(mutex_id);
}

static uint32_t svf_dpi_create_cond_w()
{
	svSetScope(svf_dpi_scope);
	return svf_dpi_create_cond();
}

static void svf_dpi_cond_wait_w(uint32_t cond_id, uint32_t mutex_id)
{
	svSetScope(svf_dpi_scope);
	return svf_dpi_cond_wait(cond_id, mutex_id);
}

static void svf_dpi_cond_notify_w(uint32_t cond_id)
{
	svSetScope(svf_dpi_scope);
	svf_dpi_cond_notify(cond_id);
}

static void svf_dpi_cond_notify_all_w(uint32_t cond_id)
{
	svSetScope(svf_dpi_scope);
	svf_dpi_cond_notify_all(cond_id);
}

static void svf_dpi_thread_yield_w()
{
	svSetScope(svf_dpi_scope);
	svf_dpi_thread_yield();
}

static svf_dpi_api_t prv_svf_dpi_api = {
		&svf_dpi_create_thread_w, // create_thread
		&svf_dpi_create_mutex_w,
		&svf_dpi_mutex_lock_w,
		&svf_dpi_mutex_unlock_w,
		&svf_dpi_create_cond_w,
		&svf_dpi_cond_wait_w,
		&svf_dpi_cond_notify_w,
		&svf_dpi_cond_notify_all_w,
		&svf_dpi_thread_yield_w
};

extern "C" int svf_dpi_runtest(const char *testname);
int svf_dpi_runtest(const char *testname)
{
	fprintf(stdout, "--> svf_dpi_runtest\n");
	svf_runtest(testname);
	fprintf(stdout, "<-- svf_dpi_runtest\n");
	return 0;
}


extern "C" int unsigned svf_dpi_init();
int unsigned svf_dpi_init()
{
	fprintf(stdout, "svf_dpi_init\n");
	svf_dpi_scope = svGetScope();
	set_svf_dpi_api(&prv_svf_dpi_api);

	return 1;
}

extern "C" void svf_dpi_set_config_string(const char *path, const char *key, const char *val);
void svf_dpi_set_config_string(const char *path, const char *key, const char *val) {
	svf_config_db &db = svf_config_db::get_default();

	db.set_string(path, key, val);
}


