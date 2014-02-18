#ifndef INCLUDED_VECTORS_H
#define INCLUDED_VECTORS_H

typedef void (*vector_f)(void);


void set_swi_vector(vector_f f);

void set_irq_vector(vector_f f);

void set_firq_vector(vector_f f);

#endif /* INCLUDED_VECTORS_H */

