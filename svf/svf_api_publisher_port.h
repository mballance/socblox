/*
 * svf_api_publisher_port.h
 *
 *  Created on: Dec 24, 2013
 *      Author: ballance
 *
 * Copyright 2013 Matthew Ballance
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef SVF_API_PUBLISHER_PORT_H_
#define SVF_API_PUBLISHER_PORT_H_
#include <vector>
#include <stdint.h>
#include "svf_api_export.h"

using namespace std;


template <class P> class svf_api_publisher_port {
	private:
		vector<svf_api_export<P> *>			m_observers;

	public:

		void connect(svf_api_export<P> &exp);

		const vector<svf_api_export<P> *> observers() const;

		template <typename ...Ts> void operator()(void (P::*method)(Ts...), Ts... args) {
			for (uint32_t i=0; i<m_observers.size(); i++) {
				P *api = m_observers.at(i)->provides();
				(*api.*method)(args...);
			}
		}

};

template <class P> void svf_api_publisher_port<P>::connect(svf_api_export<P> &exp)
{
	m_observers.push_back(&exp);
}


#endif /* SVF_API_PUBLISHER_PORT_H_ */

