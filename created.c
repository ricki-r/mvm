#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{ 
    if((argv[1] == NULL) || (argv[2] == NULL))
    {
        fprintf(stderr, "mumu you missed something\n");
        exit(EXIT_FAILURE);
    }
    unsigned size = atoi(argv[2]) * 1024 * 1024;
    FILE *f = fopen64(argv[1], "w");
    char *pad = malloc(size);
    memset(pad, 0, size);
    fwrite(pad, size, 1, f);
}