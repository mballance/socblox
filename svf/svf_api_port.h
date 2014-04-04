/*
 * svf_api_port.h
 *
 *  Created on: Dec 14, 2013
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

#ifndef SVF_API_PORT_H_
#define SVF_API_PORT_H_
#include "svf_api_export.h"

template <class C> class svf_api_port {

	public:

		svf_api_port() : m_api(0) {}

		C *operator ()() { return m_api; }

		C *operator ->() { return m_api; }

		void connect(svf_api_export<C> &exp) {
			m_api = exp.provides();
		}

	private:
		C						*m_api;

};




#endif /* SVF_API_PORT_H_ */
