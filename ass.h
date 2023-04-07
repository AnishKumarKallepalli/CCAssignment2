#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX 100

typedef struct
{
    char *name;
    float value;
    char *type;
} Token;

Token symbols[MAX];
int num = 0;

int lookup_symbol(char *name)
{
    int i;
    for (i = 0; i < num; i++)
    {
        if (strcmp(name, symbols[i].name) == 0)
        {
            return i;
        }
    }
    return -1;
}

void add_symbol(char *name, float value, char *type)
{
    if (num >= MAX)
    {
        fprintf(stderr, "Symbol table is full\n");
        exit(EXIT_FAILURE);
    }

    symbols[num].name = strdup(name);
    symbols[num].value = value;
    symbols[num].type = strdup(type);
    num++;
}

void update_symbol(char *name, float value)
{
    symbols[lookup_symbol(name)].value = value;
}

void print_table()
{
    int i;
    printf("Symbol table:\n");
    for (i = 0; i < num; i++)
    {
        printf("Name: %s, Value: %f, Type: %s\n", symbols[i].name, symbols[i].value, symbols[i].type);
    }
}