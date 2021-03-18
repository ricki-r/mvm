#include "headers/types.h"

struct idt
{
    word base_lo;
    word selector;
    byte resvbits;
    byte idt_bitm;
    word base_hi;
}__attribute__((packed));

struct idt intrpt[256];
void load_idt()
{
    
}