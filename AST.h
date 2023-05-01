#ifndef TEMPLATE_H 
#define TEMPLATE_H 

#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

typedef struct ASTNode{
     // Name of node
     char name[50];
     struct ASTNode* children[50];
     // # of children
     int child_cnt;
} ASTNode;
 
static void add_child(ASTNode* root, ASTNode** children) {
     // Add children to root
     int c = root->child_cnt;
     while (children != NULL) {
          root->children[c++] = *children;
          children++;
          root->child_cnt++;
     }
}

static void add_child(ASTNode* root, int num, ...){
    va_list ap;
    va_start(ap, num);

    for(int i = 0; i < num; i++){
        ASTNode* to_add = va_arg(ap, ASTNode*);
        root->children[root->child_cnt] = to_add;
        root->child_cnt++;
    }

    va_end(ap);

    return;
}
 
static ASTNode* create_node(char* name) {
     // Creates node
     ASTNode* root = (ASTNode*)malloc(sizeof(ASTNode));
     strcpy(root->name, name);
     return root;
}

#endif