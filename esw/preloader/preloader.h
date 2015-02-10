/*
 * preloader.h
 *
 *  Created on: Feb 6, 2015
 *      Author: ballance
 */

#ifndef PRELOADER_H_
#define PRELOADER_H_
#include "preloader_msg_if.h"
#include "preloader_msg.h"

class preloader {

	public:
		preloader();

		virtual ~preloader();

		void run(preloader_msg_if *msg_if);

	private:

};

#endif /* PRELOADER_H_ */
