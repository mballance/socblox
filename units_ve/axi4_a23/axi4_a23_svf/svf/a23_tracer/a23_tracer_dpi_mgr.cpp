/*
 * a23_tracer_dpi_mgr.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "a23_tracer_dpi_mgr.h"
#include <stdio.h>
#include "dpi/svf_dpi.h"

extern "C" int axi4_a23_svf_tracer_register();
int axi4_a23_svf_tracer_register()
{
	fprintf(stdout, "axi4_a23_svf_tracer_register\n");
	svScope scope = svGetScope();
	fprintf(stdout, "scope=%p\n", scope);
	const char *name = svGetNameFromScope(scope);

	fprintf(stdout, "axi4_a23_svf_tracer_register: %s\n", name);

	a23_tracer_dpi_mgr::register_bfm(name);
	/*
	 */

	return 0;
}

extern "C" int axi4_a23_svf_tracer_mem_access(
		uint32_t		addr,
		uint32_t		is_write,
		uint32_t		data
		);
int axi4_a23_svf_tracer_mem_access(
		uint32_t		addr,
		uint32_t		is_write,
		uint32_t		data
		)
{
	const char *scope = svGetNameFromScope(svGetScope());
	a23_tracer_dpi_closure *c = a23_tracer_dpi_mgr::get_closure(scope);

	if (c) {
		c->call(&a23_tracer_if::mem_access, addr, (bool)is_write, data);
	} else {
		fprintf(stdout, "Error: mem_access(0x%08x, %s, 0x%08x) no tracer module for %s\n",
					addr, (is_write)?"write":"read", data, scope);
	}
	return 0;
}

extern "C" int axi4_a23_svf_tracer_execute(
		uint32_t		addr,
		uint32_t		op
		);
int axi4_a23_svf_tracer_execute(
		uint32_t		addr,
		uint32_t		op
		)
{
	const char *scope = svGetNameFromScope(svGetScope());
	a23_tracer_dpi_closure *c = a23_tracer_dpi_mgr::get_closure(scope);

	if (c) {
		c->call(&a23_tracer_if::execute, addr, op);
	} else {
		fprintf(stdout, "Error: execute(0x%08x, 0x%08x) no tracer module for %s\n",
					addr, op, scope);
	}
	return 0;
}

extern "C" int axi4_a23_svf_tracer_regchange(
		uint32_t		reg,
		uint32_t		val
		);
int axi4_a23_svf_tracer_regchange(
		uint32_t		reg,
		uint32_t		val
		)
{
	const char *scope = svGetNameFromScope(svGetScope());
	a23_tracer_dpi_closure *c = a23_tracer_dpi_mgr::get_closure(scope);

	if (c) {
		c->call(&a23_tracer_if::regchange, reg, val);
	} else {
		fprintf(stdout, "Error: regchange(0x%08x, 0x%08x) no tracer module for %s\n",
					reg, val, scope);
	}
	return 0;
}


void a23_tracer_dpi_mgr::connect(
		const string							&target,
		svf_api_publisher_port<a23_tracer_if>	&port)
{
	map<string, a23_tracer_dpi_closure *>::iterator it;

	it = m_closure_map.find(target);

	a23_tracer_dpi_closure *c;

	if (it == m_closure_map.end()) {
		// Must add
		c = new a23_tracer_dpi_closure(target);
		m_closure_map[target] = c;
	} else {
		c = it->second;
	}

	c->connect(&port);
}

void a23_tracer_dpi_mgr::register_bfm(const string &target)
{
	map<string, a23_tracer_dpi_closure *>::iterator it;

	it = m_closure_map.find(target);

	a23_tracer_dpi_closure *c;

	if (it == m_closure_map.end()) {
		// Must add
		c = new a23_tracer_dpi_closure(target);
		m_closure_map[target] = c;
	}
}

a23_tracer_dpi_closure *a23_tracer_dpi_mgr::get_closure(const string &target)
{
	map<string, a23_tracer_dpi_closure *>::iterator it;

	it = m_closure_map.find(target);

	a23_tracer_dpi_closure *c = 0;

	if (it != m_closure_map.end()) {
		c = it->second;
	}

	return c;
}

map<string, a23_tracer_dpi_closure *> a23_tracer_dpi_mgr::m_closure_map;



