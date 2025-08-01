#include <stdio.h>
#include <assert.h>
#include "vector.h"

// To compile: gcc -Ivector -o Test vector.c main.c 

void IntVectorLoop(Vector vec)
{
    for(int i = 0; i < vec.len; i++)
    {
        int* val = (int*)VectorGet(&vec, i);
        printf("Item %i: %i\n", i, *val);
    }
}

typedef struct {
    int integer;
    float floating;
} MultiData;

void MultidataVectorLoop(Vector multiDataVec)
{
    for(int i = 0; i < multiDataVec.len; i++)
    {
        MultiData* val = (MultiData*)VectorGet(&multiDataVec, i);
        printf("Int %i: %i\n", i, val->integer);
        printf("Float %i: %.1f\n", i, ((MultiData*)VectorGet(&multiDataVec, i))->floating); // Use another pair of braces for a one-liner solution.
    }
}

int main() {
    Vector vec = NewVector(sizeof(int));
    
    int x = 1;
    int y = 2;
    
    VectorPushBackPointer(&vec, &x); // We can only push back pointers to variables.
    VectorPushBack(&vec, y); // We can push back regular variables. Don't use reference operator here!
    VectorPushBack(&vec, 3); // We can also push back regular values.
    
    IntVectorLoop(vec); // Prints 1, 2, 3.
    
    int newx = 4;
    VectorSetPointer(&vec, 0, &newx); // Set the value to a specific index to a new one. This requires a pointer to a variable.
    printf("--NEW X SET--\n");
    
    IntVectorLoop(vec); // Prints the same, where the first value is 4.
    
    VectorSet(&vec, 0, 5); // Same without the pointer.
    printf("--NEW X CHANGED DIRECTLY--\n");
    
    IntVectorLoop(vec); // Prints the same, where the first value is 5.
    
    //ClearVector(&vec);
    DeleteVector(&vec); // Frees the vector memory.
    
    printf("--STRUCT TEST--\n");
    
    Vector multiDataVec = NewVector(sizeof(MultiData));
    
    MultiData multiData1 = {4, 8.7f};
    MultiData multiData2 = {5, 6.9f};
    
    VectorPushBack(&multiDataVec, multiData1);
    VectorPushBack(&multiDataVec, multiData2);
    
    MultidataVectorLoop(multiDataVec);
    
    VectorRemoveAt(&multiDataVec, 1); // Removes the value at a specific index.
    printf("--SECOND MULTIDATA REMOVED--\n");
    
    MultidataVectorLoop(multiDataVec);
    
    MultiData multiData3 = {6, 2.4f};
    VectorPushBack(&multiDataVec, multiData3);
    printf("--ANOTHER MULTIDATA ADDED--\n");
    
    MultidataVectorLoop(multiDataVec);
    
    VectorPop(&multiDataVec); // Removes the last value.
    printf("--MULTIDATA POPPED--\n");
    
    MultidataVectorLoop(multiDataVec);
    
    printf("--GETS AND SETS--\n");
    
    if(((MultiData*)VectorGet(&multiDataVec, 0))->floating < 10) printf("1st float less than 10!\n"); // Notice the use of more braces for a one-liner solution.
    
    printf("--FLOAT CHANGED--\n");
    
    ((MultiData*)VectorGet(&multiDataVec, 0))->floating = 15.8f;
    MultidataVectorLoop(multiDataVec);
    if(((MultiData*)VectorGet(&multiDataVec, 0))->floating < 10) printf("1st float less than 10!\n"); // Doesn't print!
    
    VectorSet(&multiDataVec, 0, ((MultiData){((MultiData*)VectorGet(&multiDataVec, 0))->integer, 17.9f})); // Alternatively...
    MultidataVectorLoop(multiDataVec);
    if(((MultiData*)VectorGet(&multiDataVec, 0))->floating < 10) printf("1st float less than 10!\n"); // Still doesn't print!
    
    printf("--MULTIDATA VECTOR CLEARED--\n");
    
    ClearVector(&multiDataVec); // Clears the whole vector.
    MultidataVectorLoop(multiDataVec); // Nothing prints!
    
    DeleteVector(&multiDataVec);
    return 0;
}
