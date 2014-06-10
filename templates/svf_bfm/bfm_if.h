#ifndef INCLUDED_${name}_IF_H
#define INCLUDED_${name}_IF_H
#include <stdint.h>

class ${name}_target_if {
	public:

		virtual ~${name}_target_if() {}

		// TODO: Virtual methods to be implemented by the SystemVerilog side of the BFM
};

class ${name}_host_if {
	public:

		virtual ~${name}_host_if() {}

		// TODO: Virtual methods to be implemented by the SVF side of the BFM
};

#endif /* INCLUDED_${name}_IF_H */
