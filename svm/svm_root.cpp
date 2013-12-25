/*
 * svm_root.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#include "svm_root.h"
#include "svm_cmdline.h"
#include <stdio.h>

svm_root::svm_root(const char *name) :
	svm_component(name, 0), m_cmdline(0)
{

}

svm_root::~svm_root()
{
	// TODO Auto-generated destructor stub
}

void svm_root::elaborate()
{
	do_build(this);
//	build();

	do_connect(this);
//	connect();
}

void svm_root::run()
{
	do_start(this);
//	start();

	// Wait for all objections to be dropped
}

svm_cmdline &svm_root::cmdline()
{
	if (!m_cmdline) {
		m_cmdline = &svm_cmdline::get_default();
	}

	return *m_cmdline;
}

void svm_root::do_build(svm_component *level)
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

void svm_root::do_connect(svm_component *level)
{
	int entry_size = level->m_children.size();
	fprintf(stdout, "do_connect: level=%p %s entry_size=%d\n", level, level->get_name().c_str(), entry_size);
	for (int i=0; i<level->m_children.size(); i++) {
		do_connect(level->m_children.at(i));
	}
	level->connect();
}

void svm_root::do_start(svm_component *level)
{
	for (int i=0; i<level->m_children.size(); i++) {
		do_start(level->m_children.at(i));
	}
	level->start();
}

