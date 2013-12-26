/*
 * svm_component.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#include "svm_component.h"
#include "svm_root.h"

svm_component::svm_component(const char *name, svm_component *parent) :
	m_parent(parent), m_name(name) {

	if (m_parent) {
		m_parent->m_children.push_back(this);
	}
}

svm_component::~svm_component() {
	// TODO Auto-generated destructor stub
}

const string &svm_component::get_name() const
{
	return m_name;
}

void svm_component::build()
{
	// Do nothing
}

void svm_component::connect()
{
	// Do nothing
}

void svm_component::start()
{
	// Do nothing
}

void svm_component::raise_objection()
{
	svm_root *root = get_root();
	root->raise_objection();
}

void svm_component::drop_objection()
{
	svm_root *root = get_root();
	root->drop_objection();
}

svm_root *svm_component::get_root()
{
	svm_component *p = m_parent;

	while (p->m_parent) {
		p = p->m_parent;
	}

	return static_cast<svm_root *>(p);
}
