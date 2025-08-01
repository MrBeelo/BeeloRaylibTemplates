#ifndef VECTOR_H
#define VECTOR_H

#include <stddef.h>

typedef struct {
    int len;
    size_t elem_size;
    void* contents;
} Vector;

Vector NewVector(size_t elem_size);
void DeleteVector(Vector* vec);
void ClearVector(Vector* vec);
int VectorLength(Vector* vec);
void VectorPushBackPointer(Vector* vec, void* val);
void VectorRemoveAt(Vector* vec, int index);
void VectorPop(Vector* vec);
void* VectorGet(Vector* vec, int index);
void VectorSetPointer(Vector* vec, int index, void* val);

#define VectorPushBack(vec, value) do {  \
    __typeof__(value) _val = (value);    \
    VectorPushBackPointer((vec), &_val); \
} while (0)

#define VectorSet(vec, index, value) do {  \
    __typeof__(value) _val = (value);      \
    VectorSetPointer((vec), index, &_val); \
} while (0)

#endif