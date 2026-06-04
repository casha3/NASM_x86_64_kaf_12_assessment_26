#include <stdio.h>
#include <stdlib.h>  // для atoi

int f(int x);   // объявление ассемблерной функции

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <int>\n", argv[0]);
        return 1;
    }
    int input = atoi(argv[1]);   // преобразуем строку в целое
    int result = f(input);
    printf("f(%d) = %d\n", input, result);
    return 0;
}
