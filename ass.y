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
%token <ival> INTC <strval> TYPE <strval> VAR <ch> CHARC <fval> FLOATC 
%token PL MIN MUL DIV MOD NOT LT GT EQ AND OR SC CM OB CB OC CC IF WHILE SW FOR ELSE CL CASE DF OS CS VOID BREAK CONTINUE RET

%%

p : stmt_list
  ;

stmt_list : simple_stmt stmt_list
          | comp_stmt stmt_list
          ;

stmt : simple_stmt
     | comp_stmt
     | iter_stmt
     | cntl_stmt
     ;

simple_stmt : decl_stmt SC 
            | asg_stmt SC
            | expr SC
            | jump_stmt SC
            | SC
            ;

comp_stmt : OC stmt_list CC
          ;

iter_stmt : for_stmt
          | while_stmt
          ;

cntl_stmt : if_stmt
          | switch_list
          ;

jump_stmt : BREAK
          | CONTINUE
          | RET
          | RET expr 
          ;

decl_stmt : TYPE init_list
          ;

init_list : init_stmt 
          | init_stmt CM init_list
          ;

init_stmt : VAR
          | VAR OS expr CS
          | VAR OS expr CS OS expr CS
          | decl_asg
          ;

decl_asg : VAR EQ expr
         | VAR OS expr CS EQ expr
         | VAR OS expr CS OS expr CS EQ expr
         | VAR OS CS EQ expr
         | VAR OS CS OS CS EQ expr
         ; 

asg_stmt : VAR EQ expr
         | VAR OS expr CS EQ expr
         | VAR OS CS EQ expr
         | VAR OS expr CS OS expr CS EQ expr
         | VAR OS expr CS OS CS EQ expr
         ;

expr : expr PL expr
     | expr MIN expr
     | expr MUL expr
     | expr DIV expr
     | expr MOD expr
     | expr EQ EQ expr
     | expr NOT EQ expr
     | expr LT expr
     | expr LT EQ expr
     | expr GT expr
     | expr GT EQ expr
     | expr AND expr
     | expr OR expr
     | MIN expr
     | NOT expr
     | VAR | VAR OS expr CS | VAR OS expr CS | VAR OS expr CS OS expr CS | VAR OS expr CS OS CS
     | constant 
     | func_call
     ;

switch_list: SW OB expr CB OC cases_list CC
;

cases_list: single_case cases_list 
| default_stmt
|
;

single_case: CASE constant CL stmt_list
;

default_stmt : DF CL stmt_list
;

constant: INTC
| FLOATC
| CHARC
;

if_stmt : IF OB expr CB stmt
        | IF OB expr CB stmt ELSE stmt 
        ;


for_stmt : FOR OB for_init SC expr SC asg_stmt CB stmt
         ;

for_init : decl_stmt
         | asg_stmt
         ;

while_stmt : WHILE OB expr CB stmt
           ;

ret_type : TYPE | VOID
         ;

func_def : ret_type VAR OB param_list CB comp_stmt
         ;
param_list : TYPE VAR
           | TYPE VAR CM param_list
           ;

func_call : VAR OB val_list CB
          ;

val_list : expr 
         | expr CM val_list
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
