/*
 * svf_bridge.cpp
 *
 *  Created on: Mar 30, 2014
 *      Author: ballance
 */

#include "svf_bridge.h"
#include "svf_bridge_socket.h"

svf_bridge::svf_bridge(const char *name, svf_component *parent) :
	svf_component(name, parent) {
	// TODO Auto-generated constructor stub
	m_alloc_list = 0;
}

svf_bridge::~svf_bridge() {
	// TODO Auto-generated destructor stub
}

void svf_bridge::start() {
	m_recv_thread.init(this, &svf_bridge::recv_loop);
	if (link_port.provides() == 0) {
		// TODO:
		fprintf(stderr, "Error: svf_bridge link port not connected\n");
	} else {
		m_recv_thread.start();
	}
}

svf_bridge_msg *svf_bridge::alloc_msg()
{
	if (m_alloc_list) {
		svf_bridge_msg *ret = m_alloc_list;
		m_alloc_list = m_alloc_list->get_next();
		ret->init();
		return ret;
	} else {
		return new svf_bridge_msg();
	}
}

void svf_bridge::free_msg(svf_bridge_msg *msg)
{
	msg->set_next(m_alloc_list);
	m_alloc_list = msg;
}

void svf_bridge::send_msg(svf_bridge_msg *msg) {
	link_port->send_message(msg->size(), msg->data());

	free_msg(msg);
}

void svf_bridge::register_socket(svf_bridge_socket *sock)
{
	uint32_t id = m_local_sockets.size()+1;
	sock->init(this, id);
	m_local_sockets.push_back(sock);

	svf_bridge_msg *msg = alloc_msg();
	msg->write32(0); // management channel ID
	msg->write32(MGMT_REGISTER_SOCKET);
	msg->write_str(sock->get_type());
	msg->write_str(sock->get_name());
	msg->write32(id); // send the local id across

	send_msg(msg);
	// Look for matches in the previously-registered remote sockets
	for (uint32_t i=0; i<m_remote_sockets.size(); i++) {
		svf_bridge_socket *rsock = m_remote_sockets.at(i);

		if (rsock->type().equals(sock->type()) &&
				rsock->name().equals(sock->name())) {
			sock->notify_connected(rsock);
			break;
		}
	}
}

void svf_bridge::recv_loop() {

	while (true) {
		int32_t sz = link_port->get_next_message_sz(true);

		svf_bridge_msg  *msg = alloc_msg();
		msg->ensure_space(sz);

		link_port->read_next_message(msg->data());
		msg->set_size(sz);

//		fprintf(stdout, "Message: sz=%d\n", sz);
//		for (uint32_t i=0; i<sz; i++) {
//			fprintf(stdout, "  Data[%d] = 0x%08x\n", i, msg->data()[i]);
//		}

		uint32_t socket_id = msg->read32();

		if (socket_id == 0) {
			// Management channel
			mgmt_channel_msg_e req = (mgmt_channel_msg_e)msg->read32();

			switch (req) {
				case MGMT_REGISTER_SOCKET: {
					svf_string type, name;
					uint32_t id;

					msg->read_str(type);
					msg->read_str(name);
					id = msg->read32();

					svf_bridge_socket *rsock = new svf_bridge_socket(type.c_str(), name.c_str());
					rsock->init(this, id);

					m_remote_sockets.append(rsock);

					// Search to see if there is a local socket to connect to
					for (uint32_t i=0; i<m_local_sockets.size(); i++) {
						svf_bridge_socket *lsock = m_local_sockets.at(i);

						if (lsock->type().equals(rsock->type()) &&
								lsock->name().equals(rsock->name())) {
							lsock->notify_connected(rsock);
							break;
						}
					}
					} break;

				default:
					fprintf(stdout, "Unknown bridge message %d\n", req);
					break;
			}
		} else {
			if (socket_id <= m_local_sockets.size() && m_local_sockets.at(socket_id-1)) {
				svf_bridge_socket *s = m_local_sockets.at(socket_id-1);
				s->msg_received(msg);
			} else {
				fprintf(stdout, "Error: message sent to unknown socket %d\n", socket_id);
			}
		}
	}
}


