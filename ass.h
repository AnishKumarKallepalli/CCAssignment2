#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX 100
// Remember value is a void pointer so when accessing its value use type-casting
// for array data type is 1D-int or 2D-int..etc for all datatypes
// if u are giving a normal symbol keep dimentions as -1, make sure to give dimentions correctly
struct Token
{
    char *name;
    void *value;
    char *type;
    int dim1;
    int dim2;
};
struct node
{
    int curr_symbols;
    int num_children;
    struct Token symbols[MAX];
    struct node *parent;
    struct node *children[MAX];
};

struct node *add_child(struct node *parent)
{
    struct node *newNode = (struct node *)malloc(sizeof(struct node));
    if (parent->num_children >= MAX)
    {
        fprintf(stderr, "Max children\n");
        exit(EXIT_FAILURE);
    }
    parent->children[parent->num_children] = newNode;
    parent->num_children++;
    newNode->curr_symbols = 0;
    newNode->num_children = 0;
    newNode->parent = parent;
    return newNode;
}

struct node *merge_two(struct node *left,struct node *right,struct node *parent)
{
    struct node *merged = (struct node *)malloc(sizeof(struct node));
    if (((left->num_children)+(right->num_children)) >= MAX)
    {
        fprintf(stderr, "Too many children to merge\n");
        exit(EXIT_FAILURE);
    }
    merged->num_children=left->num_children + right->num_children;
    merged->curr_symbols = left->curr_symbols + right->curr_symbols;

    for(int i=0;i<left->num_children;i++)
    {
        merged->children[i]=left->children[i];
    }
    for(int i=left->num_children;i<merged->num_children;i++)
    {
        merged->children[i]=right->children[i-left->num_children];
    }

    for(int i=0;i<left->curr_symbols;i++)
    {
        merged->symbols[i]=left->symbols[i];
    }
    for(int i=left->curr_symbols;i<merged->curr_symbols;i++)
    {
        merged->symbols[i]=right->symbols[i-left->curr_symbols];
    }

    merged->parent = parent;
    return merged;
}

struct node *create_block()
{
    struct node *newNode = (struct node *)malloc(sizeof(struct node));
    newNode->curr_symbols = 0;
    newNode->num_children = 0;
    newNode->parent = NULL;
    return newNode;
}

struct node *add_sibling(struct node *brother)
{
    struct node *parent = brother->parent;
    return add_child(parent);
}

struct node *get_parent(struct node *a)
{
    struct node *parent = a->parent;
    return parent;
}

int lookup_symbol(struct node *a, char *name)
{
    int num = a->curr_symbols;
    int i;
    for (i = 0; i < num; i++)
    {
        if (strcmp(name, a->symbols[i].name) == 0)
        {
            return i;
        }
    }
    return -1;
}

void add_symbol(struct node *a, char *name, char *type, int dim1, int dim2)
{
    int num = a->curr_symbols;
    for (int i = 0; i < num; i++)
    {
        if (strcmp(a->symbols[i].name, name) == 0)
        {
            printf("Symbol Already Initialized\n");
            exit(0);
        }
    }
    if (num >= MAX)
    {
        printf("Symbol table is full\n");
        exit(0);
    }
    a->symbols[num].name = strdup(name);
    a->symbols[num].type = strdup(type);
    a->symbols[num].dim1 = dim1;
    a->symbols[num].dim2 = dim2;
    if (strcmp(type, "int") == 0 || strcmp(type, "1D-int") || strcmp(type, "2D-int"))
        a->symbols[num].value = (int *)calloc(1, sizeof(int));
    else if (strcmp(type, "char") == 0 || strcmp(type, "1D-char") || strcmp(type, "2D-char"))
        a->symbols[num].value = (char *)calloc(1, sizeof(char));
    else if (strcmp(type, "float") == 0 || strcmp(type, "1D-float") || strcmp(type, "2D-float"))
        a->symbols[num].value = (float *)calloc(1, sizeof(float));
    a->curr_symbols++;
}

void update_symbol(struct node *a, char *name, void *value)
{
    a->symbols[lookup_symbol(a, name)].value = value;
}

void print_node(struct node *a)
{
    int num = a->curr_symbols;
    int i;
    printf("Symbol table:\n");
    for (i = 0; i < num; i++)
    {
        if (strcmp(a->symbols[i].type, "int") == 0)
            printf("Name: %s, Value: %d, Type: %s\n", a->symbols[i].name, *(int *)(a->symbols[i].value), a->symbols[i].type);
        else if (strcmp(a->symbols[i].type, "char") == 0)
            printf("Name: %s, Value: %c, Type: %s\n", a->symbols[i].name, *(char *)(a->symbols[i].value), a->symbols[i].type);
        else if (strcmp(a->symbols[i].type, "float") == 0)
            printf("Name: %s, Value: %f, Type: %s\n", a->symbols[i].name, *(float *)(a->symbols[i].value), a->symbols[i].type);
        else if (strcmp(a->symbols[i].type, "1D-int") == 0 || strcmp(a->symbols[i].type, "2D-int") == 0)
            printf("Name: %s, Value: %d, Type: %s Dimention 1: %d Dimention 2: %d\n", a->symbols[i].name, *(int *)(a->symbols[i].value), a->symbols[i].type, a->symbols[i].dim1, a->symbols[i].dim2);
        else if (strcmp(a->symbols[i].type, "1D-float") == 0 || strcmp(a->symbols[i].type, "2D-float") == 0)
            printf("Name: %s, Value: %f, Type: %s Dimention 1: %d Dimention 2: %d\n", a->symbols[i].name, *(float *)(a->symbols[i].value), a->symbols[i].type, a->symbols[i].dim1, a->symbols[i].dim2);
        else if (strcmp(a->symbols[i].type, "1D-char") == 0 || strcmp(a->symbols[i].type, "2D-char") == 0)
            printf("Name: %s, Value: %c, Type: %s Dimention 1: %d Dimention 2: %d\n", a->symbols[i].name, *(char *)(a->symbols[i].value), a->symbols[i].type, a->symbols[i].dim1, a->symbols[i].dim2);
    }
}