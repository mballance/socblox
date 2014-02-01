/*
 * svf_thread_mutex_sc.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */
#include "svf_thread_mutex.h"
#include "svf_dpi_int.h"
#include <stdio.h>

svf_thread_mutex_h svf_thread_mutex::create()
{
	return (svf_thread_mutex_h *)get_svf_dpi_api()->create_mutex();
}

void svf_thread_mutex::destroy(svf_thread_mutex_h m)
{
//	get_svf_dpi_api()->mutex_destroy((uint32_t)m);
}

void svf_thread_mutex::lock(svf_thread_mutex_h m)
{
	get_svf_dpi_api()->mutex_lock((uint32_t)m);
}

void svf_thread_mutex::unlock(svf_thread_mutex_h m)
{
	get_svf_dpi_api()->mutex_unlock((uint32_t)m);
}



