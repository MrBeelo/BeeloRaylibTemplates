#include <stdio.h>

#define DYNARR_IMPL
#include "dynarr.h"

void print_int_dynarr(DynamicArray arr, bool newline) {
    printf("{");
    for(int i = 0; i < arr.len; i++) {
        int* val = dynarr_get(&arr, i, int);
        printf("%d", *val);
        if(i < arr.len - 1) printf(", ");
    }
    printf("}");
    if(newline) printf("\n");
} 

int main() {
    DynamicArray arr = new_dynarr(int);
    dynarr_push_back(&arr, 67);
    dynarr_push_back(&arr, 420);
    dynarr_push_back(&arr, 1337);
    dynarr_push_back(&arr, 80085);

    dynarr_pop(&arr);
    dynarr_remove(&arr, 1);
    dynarr_set(&arr, 1, 1984);
    dynarr_clear(&arr);

    print_int_dynarr(arr, true);
    
    return 0;
}