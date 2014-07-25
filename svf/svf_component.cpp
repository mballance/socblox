/*
 * svf_component.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#include "svf_component.h"
#include "svf_root.h"
#include <stdio.h>

svf_component::svf_component(const char *name, svf_component *parent) :
	m_parent(parent), m_name(name) {

	if (m_parent) {
		m_parent->m_children.push_back(this);
	}
}

svf_component::~svf_component() {
	// TODO Auto-generated destructor stub
}

const svf_string &svf_component::get_name() const
{
	return m_name;
}

void svf_component::build()
{
	// Do nothing
}

void svf_component::connect()
{
	// Do nothing
}

void svf_component::start()
{
	// Do nothing
}

void svf_component::shutdown()
{
	// Do nothing
}

void svf_component::raise_objection()
{
	svf_root *root = get_root();
	root->raise_objection();
}

void svf_component::drop_objection()
{
	svf_root *root = get_root();
	root->drop_objection();
}

bool svf_component::get_config_string(const char *key, const char **val)
{
	svf_root *root = get_root();

	fprintf(stderr, "root=%p\n", root);

	// TODO: get path
	return root->config_db().get_string("", key, val);
}

svf_root *svf_component::get_root()
{
	if (m_parent) {
		svf_component *p = m_parent;

		fprintf(stderr, "--> get_root %p\n", p);

		while (p->m_parent) {
			fprintf(stderr, "  -- p=%p\n", p);
			p = p->m_parent;
		}

		fprintf(stderr, "<-- get_root\n");

		return static_cast<svf_root *>(p);
	} else {
		return static_cast<svf_root *>(this);
	}
}
