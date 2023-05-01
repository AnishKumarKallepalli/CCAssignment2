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
%token <ival> INTC <strval> VAR <ch> CHARC <fval> FLOATC 
%token PL MIN MUL DIV MOD NOT LT GT EQ AND OR SC CM OB CB OC CC IF WHILE SW FOR ELSE CL CASE DF OS CS VOID BREAK CONTINUE RET DEQ NEQ LEQ GEQ
%token INT CHAR FLOAT KEYWORD END

%%

p : func_list END {printf("Parse done"); return 1;}
  ;

func_list : func_defn 
          | func_list func_defn
          ;

func_defn : dec_spec declarator comp_stmt
          ;
          
stmt_list : stmt
          | stmt_list stmt
          ;


stmt : lab_stat
     | expr_stmt
     | comp_stmt
     | sel_stmt
     | iter_stmt
     | jump_stmt
     | declaration
     ;

lab_stat
	: CASE  log_or_expr CL stmt
	| DF CL stmt
	;

sel_stmt : IF OB expr CB stmt
         | IF OB expr CB stmt ELSE stmt
         | SW OB expr CB stmt
         ;

comp_stmt : OC CC
          | OC stmt_list CC
          ;

iter_stmt : WHILE OB expr CB stmt
          | FOR OB expr_stmt expr_stmt CB stmt
          | FOR OB expr_stmt expr_stmt expr CB stmt
          ;

jump_stmt : BREAK
          | CONTINUE
          | RET expr SC
          ;

declaration : dec_spec SC
            | dec_spec init_list SC 
            ;
dec_spec : type_spec 
         ;

type_spec : VOID
          | INT
          | CHAR
          | FLOAT
          ;

init_list : init_dec
          | init_list CM init_dec
          ;

init_dec : declarator 
         | declarator EQ asg_expr
         ;

declarator : VAR
           | declarator OS expr CS   
           | declarator OB param_list CB          
           | declarator OB id_list CB
           | declarator OB CB 
           ;

param_list : dec_spec declarator
           | param_list CM dec_spec declarator
           ;

id_list : VAR
        | id_list CM VAR
        ;

expr_stmt : SC
          | expr SC
          ;

expr : asg_expr
     | expr CM asg_expr
     ;

asg_expr : log_or_expr
         | unary_expr EQ asg_expr
         ;

unary_expr : postfix_expr
           | unary_op unary_expr
           ;

unary_op : MIN | NOT
         ; 

postfix_expr : prim_expr
            | postfix_expr OS expr CS
            | postfix_expr OB CB
            | postfix_expr OB arg_expr_list CB
            ;

prim_expr : VAR
          | constant
          | OB expr CB
          ;

arg_expr_list : asg_expr
              | arg_expr_list CM asg_expr
              ;

log_or_expr : log_and_expr
            | log_or_expr OR log_and_expr
            ;

log_and_expr : equ_expr
             | log_and_expr AND equ_expr 
             ;

equ_expr : rel_expr
         | equ_expr DEQ rel_expr
         | equ_expr NEQ rel_expr
         ;

rel_expr : add_expr
         | rel_expr LT add_expr
         | rel_expr GT add_expr
         | rel_expr LEQ add_expr
         | rel_expr GEQ add_expr
         ;

add_expr : mul_expr
         | add_expr PL mul_expr
         | add_expr MIN mul_expr
         ;

mul_expr : unary_expr
         | mul_expr MUL unary_expr
         | mul_expr DIV unary_expr
         | mul_expr MOD unary_expr
         ;

constant: INTC
| FLOATC
| CHARC
;

%%


void main(){
FILE *fp; int i;
    fp=fopen("input.txt","r");
    yyin=fp;
    yyparse();
    /* struct node* Parent = (struct node*) malloc(sizeof(struct node));
    Parent->curr_symbols =0;
    Parent->num_children=0;
      Parent->parent = NULL;
    add_symbol(Parent,"Test","1D-float",10,5);
    print_node(Parent); */
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
