/*
 * preloader_msg_factory.h
 *
 *  Created on: Feb 9, 2015
 *      Author: ballance
 */

#ifndef PRELOADER_MSG_FACTORY_H_
#define PRELOADER_MSG_FACTORY_H_

class preloader_msg_factory {

	public:
		preloader_msg_factory();

		virtual ~preloader_msg_factory();

		static void build_go_msg(
				uint32_t			addr,
				uint32_t			argc,
				char				**argv,
				uint32_t			*&msg,
				uint32_t			&msg_len);
};

#endif /* PRELOADER_MSG_FACTORY_H_ */
