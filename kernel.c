typedef unsigned char byte;
typedef unsigned short word;
typedef unsigned dword;
typedef unsigned long long qword;


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
void kernel_entry(struct *vbeinfo);

void kernel_entry(st)
{

}__attribute__((fastcall))