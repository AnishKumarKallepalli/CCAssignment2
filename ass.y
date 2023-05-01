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
%union {char *strval; int ival; char ch; float fval;}
%token <ival> INTEGER <strval> KEYWORD <strval> IDENTIFIER <strval> CHARACTER <ch> OPERATOR <ch> PUNCTUATOR
%token FLOAT NL EQ SC CM OB CB OC CC IF WH SW FR ELSE CL CASE DF WHILE
%token <ival> INTC <strval> TYPE <strval> VAR <ch> CHARC <fval> FLOATC 
%token PL MIN MUL DIV MOD NOT LT GT AND OR FOR OS CS VOID BREAK CONTINUE RET DEQ NEQ LEQ GEQ INT CHAR

%%
//assignment statements for arrays must have row and column
// not handling else-if
// function has to return

s: func_def s
|
;

stmt_list: statement stmt_list
;

expr_stmt : expr_stmt PL expr_stmt
     | expr_stmt MIN expr_stmt
     | expr_stmt MUL expr_stmt
     | expr_stmt DIV expr_stmt
     | expr_stmt MOD expr_stmt
     | expr_stmt EQ EQ expr_stmt
     | expr_stmt NOT EQ expr_stmt
     | expr_stmt LT expr_stmt
     | expr_stmt LT EQ expr_stmt
     | expr_stmt GT expr_stmt
     | expr_stmt GT EQ expr_stmt
     | expr_stmt AND expr_stmt
     | expr_stmt OR expr_stmt
     | MIN expr_stmt
     | NOT expr_stmt
     | VAR 
     | VAR OS expr_stmt CS 
     | VAR OS expr_stmt CS 
     | VAR OS expr_stmt CS OS expr_stmt CS 
     | VAR OS expr_stmt CS OS CS
     | constant 
     | func_call
     ;

constant: INTEGER
| FLOAT
| CHARACTER
;

comp_stmt : OC stmt_list CC
;

decl_stmt: TYPE identifier_list
;

identifier_list: init_stmt CM identifier_list
| init_stmt
;


init_stmt : VAR
          | VAR OS expr_stmt CS
          | VAR OS expr_stmt CS OS expr_stmt CS
          | VAR OS expr_stmt CS OS CS
          | VAR EQ expr_stmt
          ;

assign_stmt : VAR EQ expr_stmt
         | VAR OS INTEGER CS EQ expr_stmt
         | VAR OS INTEGER CS OS INTEGER CS EQ expr_stmt
;
switch_list: SW OB expr_stmt CB OC cases_list CC
;

cases_list: single_case cases_list 
| default_stmt
|
;

single_case: CASE constant CL stmt_list
;

default_stmt : DF CL stmt_list
;

if_stmt: IF OB expr_stmt CB statement
| IF OB expr_stmt CB statement ELSE statement
;

while_stmt: WH OB expr_stmt CB statement
;

for_stmt : FOR OB for_init SC expr_stmt SC assign_stmt CB statement
         ;

for_init : decl_stmt
         | assign_stmt
         ;

statement: decl_stmt SC
| assign_stmt SC
| if_stmt
| for_stmt
| while_stmt
| switch_list
| comp_stmt
| func_call
;

jump_stmt :| RET
          | RET expr_stmt
          ;

func_def : ret_type VAR OB param_list CB comp_stmt
         ;

ret_type : TYPE | VOID
         ;

param_list : TYPE val_list
|
           ;

func_call : VAR OB val_list CB
          ;

val_list : VAR 
         | VAR CM val_list
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
    printf("Error\n");
    exit(0);
}

void syntax_error(int line){
    printf("Syntax Error on line : %d\n",line);
    exit(0);
}