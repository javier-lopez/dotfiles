#include <stdio.h>
#include <stdlib.h>
++HERE++

int main(int argc, char const* argv[])
{
    fflush(stdout);
    if (ferror(stdout))
        exit(EXIT_FAILURE);
    return EXIT_SUCCESS;
}
