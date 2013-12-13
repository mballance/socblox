/*
 * svm_component.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#include "svm_component.h"
#include "svm_root.h"

svm_component::svm_component(const char *name, svm_component *parent) :
	m_parent(parent) {

}

svm_component::~svm_component() {
	// TODO Auto-generated destructor stub
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

svm_root *svm_component::get_root()
{
	svm_component *p = m_parent;

	while (p->m_parent) {
		p = p->m_parent;
	}

	return static_cast<svm_root *>(p);
}
