#ifndef AST_H 
#define AST_H 

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdarg.h>
#include <assert.h>

typedef struct ASTNode{
     // Name of node
     char name[50];
     struct ASTNode* children[150];
     // # of children
     int child_cnt;
} ASTNode;
 
static void add_children(ASTNode* root, ASTNode* node) {

     for(int i = 0; i < node -> child_cnt; i++){
        int c = root->child_cnt;
        root->children[c] = node->children[i];
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
     ASTNode* root = (ASTNode*) malloc(sizeof(ASTNode));
     strcpy(root->name, name);
     fprintf(stderr, "%s\n", root->name);
     root->child_cnt = 0;
     return root;
}

static void print_syntax_tree(ASTNode* root) {
    
    if(!root)
        return;

    printf("[%s", root->name);

    for(int i = 0; i < root -> child_cnt; i++) {
        print_syntax_tree(root->children[i]);
    }
 
    printf("]");
}

#endif