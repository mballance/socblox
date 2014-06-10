#ifndef INCLUDED_timebase_IF_H
#define INCLUDED_timebase_IF_H
#include <stdint.h>

class timebase_target_if {
	public:

		virtual ~timebase_target_if() {}

		// TODO: Virtual methods to be implemented by the SystemVerilog side of the BFM
		virtual void gettime(uint64_t *) = 0;
};

class timebase_host_if {
	public:

		virtual ~timebase_host_if() {}

		// TODO: Virtual methods to be implemented by the SVF side of the BFM
};

#endif /* INCLUDED_timebase_IF_H */
