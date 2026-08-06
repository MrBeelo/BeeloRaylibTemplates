#ifndef DYNARR_H
#define DYNARR_H

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

typedef struct {
    int len; // Amount of elements
    size_t type_size; // Size of each element's type
    void* data; // Data pointer
} DynamicArray;

//---FUNCTION DECLARATIONS---//

// Returns true if the given index is out of bounds.
bool __dynarr_invalid_index(DynamicArray* arr, int index);

// Resizes the dynamic array. Increases its size by 'count' elements if
// count is positive, and decreases its size by 'count' elements if it
// is negative. Returns if the count of items to be decreased is bigger
// than the array's length.
void dynarr_resize(DynamicArray* arr, int count);

// Gets a void pointer to the element at the specified index.
// Returns NULL if the index is out of bounds.
void* __dynarr_get_voidptr(DynamicArray* arr, int index);

// Sets the element at the given index to the given pointer.
void __dynarr_set_ptr(DynamicArray* arr, int index, void* val);

// Frees the dynamic array's data.
void __dynarr_free(DynamicArray* arr);

// Clears the dynamic array. The type_size info is still kept,
// but now it can be safely changed.
void dynarr_clear(DynamicArray* arr);

// Pushes a void pointer to the end of the dynamic array.
void __dynarr_push_back_ptr(DynamicArray* arr, void* val);

// Removes the element at a speficic index. Returns if the index
// is out of bounds.
void dynarr_remove(DynamicArray* arr, int index);

// Pops the last element of the dynamic array (for convenience).
void dynarr_pop(DynamicArray* arr);

//---MACROS---//

// Produces a new dynamic array with the type specified.
#define new_dynarr(elem_type) (DynamicArray){0, sizeof(elem_type), NULL}

// Gets a pointer to the type of the element at the specified index.
#define dynarr_get(arr, index, type) (type*)__dynarr_get_voidptr((arr), (index))

// Pushes back the specified value.
#define dynarr_push_back(arr, val) do { \
    __typeof__(val) new_val = (val); \
    __dynarr_push_back_ptr((arr), &new_val); \
} while(0)

// Sets the value at the specified index.
#define dynarr_set(arr, index, val) do { \
    __typeof__(val) new_val = (val); \
    __dynarr_set_ptr((arr), (index), &new_val); \
} while(0)

//---FUNCTION IMPLEMENTATIONS---//

#ifdef DYNARR_IMPL

bool __dynarr_invalid_index(DynamicArray* arr, int index) {
    return index >= arr->len || index < 0;
}

void dynarr_resize(DynamicArray* arr, int count) {
    if(count == 0 || count < -arr->len) return;
    arr->data = realloc(arr->data, (arr->len + count) * arr->type_size);
    arr->len += count;
}

void* __dynarr_get_voidptr(DynamicArray* arr, int index) {
    if(__dynarr_invalid_index(arr, index)) return NULL;
    return (char*)arr->data + (index * arr->type_size);
}

void __dynarr_set_ptr(DynamicArray* arr, int index, void* val) {
    if(__dynarr_invalid_index(arr, index)) return;

    void* dest = __dynarr_get_voidptr(arr, index);
    memcpy(dest, val, arr->type_size);
}

void __dynarr_free(DynamicArray* arr) {
    free(arr->data);
}

void dynarr_clear(DynamicArray* arr) {
    __dynarr_free(arr);
    arr->len = 0;
    arr->data = NULL;
}

void __dynarr_push_back_ptr(DynamicArray* arr, void* val) {
    dynarr_resize(arr, 1);
    void* dest = __dynarr_get_voidptr(arr, arr->len - 1);
    memcpy(dest, val, arr->type_size);
}

void dynarr_remove(DynamicArray* arr, int index) {
    if(__dynarr_invalid_index(arr, index)) return;

    if(index < arr->len - 1) {
        void* src = __dynarr_get_voidptr(arr, index + 1);
        void* dest = __dynarr_get_voidptr(arr, index);
        memmove(dest, src, arr->type_size * (arr->len - index - 1));
    }
    
    dynarr_resize(arr, -1);
}

void dynarr_pop(DynamicArray* arr) {
    dynarr_remove(arr, arr->len - 1);
}

#endif

#endif