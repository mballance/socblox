/*
 * svf_component.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#include "svf_component.h"
#include "svf_root.h"

svf_component::svf_component(const char *name, svf_component *parent) :
	m_parent(parent), m_name(name) {

	if (m_parent) {
		m_parent->m_children.push_back(this);
	}
}

svf_component::~svf_component() {
	// TODO Auto-generated destructor stub
}

const string &svf_component::get_name() const
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

svf_root *svf_component::get_root()
{
	svf_component *p = m_parent;

	while (p->m_parent) {
		p = p->m_parent;
	}

	return static_cast<svf_root *>(p);
}
