#include "vector.h"
#include <stdlib.h>
#include <string.h>

Vector NewVector(size_t elem_size)
{
    return (Vector){0, elem_size, NULL};
}

void DeleteVector(Vector* vec) {
    free(vec->contents);
}

void ClearVector(Vector* vec) {
    DeleteVector(vec);
    vec->contents = NULL;
    vec->len = 0;
}

int VectorLength(Vector* vec) {
    return vec->len;
}

void VectorPushBackPointer(Vector* vec, void* val) {
    vec->contents = realloc(vec->contents, vec->elem_size * (vec->len + 1));
    void* target = (char*)vec->contents + vec->elem_size * vec->len;
    memcpy(target, val, vec->elem_size);
    vec->len++;
}

void VectorRemoveAt(Vector* vec, int index) {
    if (index >= vec->len) return;
    char* base = (char*)vec->contents;
    if (index < vec->len - 1) {
        void* dest = base + index * vec->elem_size;
        void* src  = base + (index + 1) * vec->elem_size;
        size_t bytes_to_move = (vec->len - index - 1) * vec->elem_size;
        memmove(dest, src, bytes_to_move);
    }

    vec->len--;
    vec->contents = realloc(vec->contents, vec->len * vec->elem_size);
}

void VectorPop(Vector *vec)
{
    VectorRemoveAt(vec, vec->len - 1);
}

void* VectorGet(Vector* vec, int index) {
    if (index < 0 || index >= vec->len) return NULL;
    return (char*)vec->contents + vec->elem_size * index;
}

void VectorSetPointer(Vector* vec, int index, void* val) {
    if (index < 0 || index >= vec->len) return;
    void* target = (char*)vec->contents + vec->elem_size * index;
    memcpy(target, val, vec->elem_size);
}