
#include <stdint.h>

class preloader_msg_if {

	public:

		virtual ~preloader_msg_if() { }

		virtual int32_t recv_next_msg_sz() = 0;

		virtual int32_t recv_msg_data(uint8_t *data, uint32_t sz) = 0;

		virtual int32_t send_msg(uint8_t *data, uint32_t sz) = 0;
};
