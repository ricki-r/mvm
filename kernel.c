#include "headers/types.h"
struct vbeinfo
{
    char sign[4];
    word version;
    char *oem;
    dword capabl;
    byte *vidmod;
    word vidmem;
    word softw_rev;
    char *vendor;
    char *prod_name;
    char *prod_rev;
    byte resv[222];
    byte oem_data[256];
}__attribute__((packed));
struct vbe_modinfo
{
    word attr;
    byte garb[112];
    word pitch;
    word width;
    word height;
    byte garb1[24];
    word bpp;
    byte garb2[112];
    byte *framebuf;
    byte *offscr_mem_off;
    word *offscr_mem_size;
    byte padding[206];
    dword mode;
}__attribute__((packed));




void __fastcall kernel_entry(struct vbeinfo *vbinf)
{ 
}