%{
    #include <stdio.h>   
    #include <stdlib.h> 
    #include "ass.h"
    extern FILE *yyin;
    char curr_type[100];
%}
//for loop for later , even arrays and functions for later
//assuming while has only expression and not assignment in grammer
// if and else is only there...no elseif and if needs statements in curly braces
//syntax error 0 means semicolon missing and 1 is for bracket
%union {char *strval; int ival; char ch;}
%token <ival> INTEGER <strval> TYPE <strval> KEYWORD <strval> IDENTIFIER <strval> CHARACTER <ch> OPERATOR <ch> PUNCTUATOR
%token FLOAT NL EQ SC CM OB CB OC CC IF WH SW FR ELSE CL CASE DF

%%
s: stmt_list
;
//we need to get the type which is in the parent one
identifier_list: IDENTIFIER CM identifier_list
| IDENTIFIER
;

decl_stmt: TYPE identifier_list SC
| TYPE identifier_list {syntax_error(0);}
;

expr_stmt : value OPERATOR expr_stmt
| OB expr_stmt CB
| OB expr_stmt {syntax_error(1);}
| expr_stmt CB {syntax_error(1);}
| value
;

assign_stmt : IDENTIFIER EQ expr_stmt SC
| IDENTIFIER EQ expr_stmt {syntax_error(0);}
;

stmt_list: statement stmt_list
|
;

statement: decl_stmt
| assign_stmt
| if_stmt
| while_stmt
| comp_stmt
;

switch_list: SW OB expr_stmt CB OC cases_list CC
| SW OB expr_stmt CB OC cases_list {syntax_error(1);}
| SW OB expr_stmt CB cases_list CC {syntax_error(1);}
| SW OB expr_stmt CB cases_list {syntax_error(1);}
| SW OB expr_stmt OC cases_list CC {syntax_error(1);}
| SW OB expr_stmt OC cases_list {syntax_error(1);}
| SW OB expr_stmt cases_list CC {syntax_error(1);}
| SW OB expr_stmt cases_list {syntax_error(1);}
| SW expr_stmt CB OC cases_list CC {syntax_error(1);}
| SW expr_stmt CB OC cases_list {syntax_error(1);}
| SW expr_stmt CB cases_list CC {syntax_error(1);}
| SW expr_stmt CB cases_list {syntax_error(1);}
| SW expr_stmt OC cases_list CC {syntax_error(1);}
| SW expr_stmt OC cases_list {syntax_error(1);}
| SW expr_stmt cases_list CC {syntax_error(1);}
;

cases_list: single_case cases_list 
| default_stmt
|
;

single_case: CASE constant CL stmt_list
;

default_stmt : DF CL stmt_list
;

constant: INTEGER
| FLOAT
| CHARACTER
;

if_stmt: IF OB expr_stmt CB comp_stmt
|IF expr_stmt CB comp_stmt {syntax_error(1);}
|IF OB expr_stmt comp_stmt {syntax_error(1);}
|IF expr_stmt comp_stmt {syntax_error(1);}
|IF OB expr_stmt CB comp_stmt ELSE comp_stmt
|IF expr_stmt CB comp_stmt ELSE comp_stmt {syntax_error(1);}
|IF OB expr_stmt comp_stmt ELSE comp_stmt {syntax_error(1);}
|IF expr_stmt comp_stmt ELSE comp_stmt {syntax_error(1);}
;

while_stmt: WH OB expr_stmt CB comp_stmt
|WH expr_stmt CB comp_stmt {syntax_error(1);}
|WH OB expr_stmt comp_stmt {syntax_error(1);}
|WH expr_stmt comp_stmt {syntax_error(1);}
;

comp_stmt : OC stmt_list CC
| OC stmt_list {syntax_error(1);}
;

value: IDENTIFIER
| INTEGER
| FLOAT
| CHARACTER
;
%%


void main(){
    FILE *fp; int i;
    fp=fopen("input.txt","r");
    yyin=fp;
    yyparse();
    struct node* Parent = (struct node*) malloc(sizeof(struct node));
    Parent->curr_symbols =0;
    Parent->num_children=0;
      Parent->parent = NULL;
    add_symbol(Parent,"Test","1D-float",10,5);
    print_node(Parent);
    exit(0);
}

void yyerror(){
    printf("error\n");
    exit(0);
}

void syntax_error(int line){
    printf("Syntax Error on line : %d\n",line);
    exit(0);
}