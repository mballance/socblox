
#include "vectors.h"


vector_f				swi_handler_f = 0;
vector_f				irq_handler_f = 0;
vector_f				firq_handler_f = 0;

void set_swi_vector(vector_f f)
{
	swi_handler_f = f;
}

void set_irq_vector(vector_f f)
{
	irq_handler_f = f;
}

void set_firq_vector(vector_f f)
{
	firq_handler_f = f;
	firq_handler_f();
}

