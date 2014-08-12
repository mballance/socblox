/*
 * svf_root.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#include "svf_root.h"
#include "svf_cmdline.h"
#include <stdio.h>

svf_root::svf_root(const char *name) :
	svf_component(name, 0), m_cmdline(0), m_config_db(svf_config_db::get_default())
{

}

svf_root::~svf_root()
{
	// TODO Auto-generated destructor stub
}

void svf_root::elaborate()
{
	do_build(this);
//	build();

	do_connect(this);
//	connect();
}

void svf_root::run()
{
	do_start(this);
//	start();

	// Wait for all objections to be dropped
	fprintf(stdout, "--> run::wait_all_dropped\n");
	m_objection.wait_all_dropped();
	fprintf(stdout, "<-- run::wait_all_dropped\n");

	do_shutdown(this);
}

void svf_root::raise_objection()
{
	m_objection.raise();
}

void svf_root::drop_objection()
{
	m_objection.drop();
}

svf_config_db &svf_root::config_db()
{
	return m_config_db;
}

svf_cmdline &svf_root::cmdline()
{
	if (!m_cmdline) {
		m_cmdline = &svf_cmdline::get_default();
	}

	return *m_cmdline;
}

void svf_root::do_build(svf_component *level)
{
	int entry_size = level->m_children.size();
	fprintf(stdout, "do_build: level=%p %s entry_size=%d\n", level, level->get_name().c_str(), entry_size);
	for (int i=0; i<entry_size; i++) {
		do_build(level->m_children.at(i));
	}
	level->build();

	// See if any components were added
	for (int i=entry_size; i<level->m_children.size(); i++) {
		do_build(level->m_children.at(i));
	}
}

void svf_root::do_connect(svf_component *level)
{
	int entry_size = level->m_children.size();
//	fprintf(stdout, "do_connect: level=%p %s entry_size=%d\n", level, level->get_name().c_str(), entry_size);
	for (int i=0; i<level->m_children.size(); i++) {
		do_connect(level->m_children.at(i));
	}
	level->connect();
}

void svf_root::do_start(svf_component *level)
{
	for (int i=0; i<level->m_children.size(); i++) {
		do_start(level->m_children.at(i));
	}
	level->start();
}

void svf_root::do_shutdown(svf_component *level)
{
	for (int i=0; i<level->m_children.size(); i++) {
		do_shutdown(level->m_children.at(i));
	}
	level->shutdown();
}
