%{
    #include <stdio.h>   
    #include <stdlib.h> 
    #include "ass.h"
    #include "AST.h"
    #include "constants.h"
    extern FILE *yyin;
    char curr_type[100];
%}
//for loop for later , even arrays and functions for later
//assuming while has only expression and not assignment in grammer
// if and else is only there...no elseif and if needs statements in curly braces
//syntax error 0 means semicolon missing and 1 is for bracket
%union {char *strval; int ival; char ch; float fval; ASTNode* ast;}
%type <ast> expr <ast> func_call <ast> val_list <ast> func_def <ast> param_list <ast> init_stmt <ast> asg_stmt <ast> cases_list <ast> switch_list <ast> default_stmt <ast> single_case <ast> param <ast> decl_asg <ast> init_list <ast> decl_stmt <ast> constant <ast> ret_type <ast> jump_stmt <ast> cntl_stmt <ast> while_stmt <ast> iter_stmt <ast> stmt <ast> for_init <ast> for_stmt <ast> if_stmt <ast> stmt_list <ast> simple_stmt <ast> comp_stmt
%token <strval> INTC <strval> TYPE <strval> VAR  <strval> CHARC <strval> FLOATC
%token PL MIN MUL DIV MOD NOT LT GT EQ AND OR SC CM OB CB OC CC IF WHILE SW FOR ELSE CL CASE DF OS CS VOID BREAK CONTINUE RET LT_EQ GT_EQ EQ_EQ NOT_EQ

%%

p : stmt_list
  ;

stmt_list : simple_stmt stmt_list {$$ = create_node(ST_LIST); add_child($$, 1, $1); add_child($$, $2->children);}
          | comp_stmt stmt_list {$$ = create_node(ST_LIST); add_child($$, 1, $1); add_child($$, $2->children);}
          ;

stmt : simple_stmt {$$ = $1;}
     | comp_stmt {$$ = $1;}
     | iter_stmt {$$ = $1;}
     | cntl_stmt {$$ = $1;}
     ;

simple_stmt : decl_stmt SC  {$$ = $1;}
            | asg_stmt SC {$$ = $1;}
            | expr SC {$$ = $1;}
            | jump_stmt SC {$$ = $1;}
            | SC
            ;

comp_stmt : OC stmt_list CC {$$ = create_node(CMP_STMT); add_child($$, $2->children);}
          ;

iter_stmt : for_stmt {$$ = $1;}
          | while_stmt {$$ = $1;}
          ;

cntl_stmt : if_stmt {$$ = $1;}
          | switch_list {$$ = $1;}
          ;

jump_stmt : BREAK {$$ = create_node("break");}
          | CONTINUE {$$ = create_node("continue");}
          | RET {$$ = create_node("return");}
          | RET expr {$$ = create_node("return"); add_child($$, 1, $2);}
          ;

decl_stmt : TYPE init_list {$$ = create_node(DECL_STMT); add_child($$, 1, $1); add_child($$, $2->children);}
          ;

init_list : init_stmt {$$ = create_node(VAR_LIST); add_child($$, 1, $1);}
          | init_stmt CM init_list {$$ = create_node(VAR_LIST); add_child($$, 1, $1); add_child($$, $3->children);}
          ;

init_stmt : VAR {$$ = create_node{$1};}
          | VAR OS expr CS {$$ = create_node(ARR); add_child($$, 2, create_node($1), $3);}
          | VAR OS expr CS OS expr CS {$$ = create_node(ARR); add_child($$, 3, create_node($1), $3, $6);}
          | decl_asg {$$ = $1;}
          ;

decl_asg : VAR EQ expr {$$ = create_node("="); add_child($$, 2, create_node($1), $3);}
         | VAR OS expr CS EQ expr {$$ = create_node("="); ASTNode *temp = create_node(ARR); add_child(temp, 2, create_node($1), $3); add_child($$, 2, temp, $6);}
         | VAR OS expr CS OS expr CS EQ expr {$$ = create_node("="); ASTNode *temp = create_node(ARR); add_child(temp, 3, create_node($1), $3, $6); add_child($$, 2, temp, $9);}
         | VAR OS CS EQ expr 
         | VAR OS CS OS CS EQ expr
         ; 

asg_stmt : VAR EQ expr {$$ = create_node("="); add_child($$, 2, create_node($1), $3);}
         | VAR OS expr CS EQ expr {$$ = create_node("="); ASTNode *temp = create_node(ARR); add_child(temp, 2, create_node($1), $3); add_child($$, 2, temp, $6);}
         | VAR OS CS EQ expr
         | VAR OS expr CS OS expr CS EQ expr {$$ = create_node("="); ASTNode *temp = create_node(ARR); add_child(temp, 3, create_node($1), $3, $6); add_child($$, 2, temp, $9);}
         | VAR OS expr CS OS CS EQ expr
         ;

expr : expr PL expr {$$ = create_node("+"); add_child($$, 2, $1, $3);}
     | expr MIN expr {$$ = create_node("-"); add_child($$, 2, $1, $3);}
     | expr MUL expr {$$ = create_node("*"); add_child($$, 2, $1, $3);}
     | expr DIV expr {$$ = create_node("/"); add_child($$, 2, $1, $3);}
     | expr MOD expr {$$ = create_node("%"); add_child($$, 2, $1, $3);}
     | expr EQ_EQ expr {$$ = create_node("=="); add_child($$, 2, $1, $3);}
     | expr NOT_EQ expr {$$ = create_node("!="); add_child($$, 2, $1, $3);}
     | expr LT expr {$$ = create_node("<"); add_child($$, 2, $1, $3);}
     | expr LT_EQ expr {$$ = create_node("<="); add_child($$, 2, $1, $3);}
     | expr GT expr {$$ = create_node(">"); add_child($$, 2, $1, $3);}
     | expr GT_EQ expr {$$ = create_node(">="); add_child($$, 2, $1, $3);}
     | expr AND expr {$$ = create_node("&&"); add_child($$, 2, $1, $3);}
     | expr OR expr {$$ = create_node("||"); add_child($$, 2, $1, $3);}
     | MIN expr {$$ = create_node(U_MIN); add_child($$, 1, $2);}
     | NOT expr {$$ = create_node("!"); add_child($$, 1, $2);}
     | VAR {$$ = create_node($1);}
     | VAR OS expr CS {$$ = create_node(ARR); add_child($$, 2, create_node($1), $3);}
     | VAR OS expr CS OS expr CS {$$ = create_node(ARR); add_child($$, 3, create_node($1), $3, $6);}
     | VAR OS expr CS OS CS 
     | constant {$$ = $1;}
     | func_call {$$ = $1;}
     ;

switch_list: SW OB expr CB OC cases_list CC {$$ = create_node(SWITCH); add_child($$, 1, $3); add_child($$, $6->children);}
;

cases_list: single_case cases_list  {$$ = create_node(CASE_L); add_child($$, 1, $1); add_child($$, $2->children);}
| default_stmt {$$ = create_node(CASE_L); add_child($$, 1, $1);}
| {$$ = create_node(CASE_L);}
;

single_case: CASE constant CL stmt_list {$$ = create_node(_CASE); add_child($$, 2, $2, $4);}
;

default_stmt : DF CL stmt_list {$$ = create_node(DEFAULT); add_child($$, 1, $3);}
;

constant: INTC {$$ = create_node($1);}
| FLOATC {$$ = create_node($1);}
| CHARC {$$ = create_node($1);}
;

if_stmt : IF OB expr CB stmt {$$ = create_node("if"); add_child($$, 2, $3, $5);}
        | IF OB expr CB stmt ELSE stmt {$$ = create_node("if"); add_child($$, 3, $3, $5, $7);}
        ;


for_stmt : FOR OB for_init SC expr SC asg_stmt CB stmt {$$ = create_node("for"); add_child($$, 4, $3, $5, $7, $9);}
         ;

for_init : decl_stmt {$$ = $1;}
         | asg_stmt {$$ = $1;}
         ;

while_stmt : WHILE OB expr CB stmt {$$ = create_node("while"); add_child($$, 2, $3, $5);}
           ;

ret_type : TYPE {$$ = create_node($1);}
         | VOID {$$ = create_node("void");}
         ;

func_def : ret_type VAR OB param_list CB comp_stmt {$$ = create_node(FUNC_DECL); add_child($$, 4, $1, create_node($2), $4, $6);}
         ;
param_list : param {$$ = create_node(PAR_LIST); add_child($$, 1, $1);}
           | param CM param_list {$$ = create_node(PAR_LIST); add_child($$, 1, $1); add_child($$, $3->children);}
           ;

param : TYPE VAR {$$ = create_node(PAR); add_child($$, 2, create_node($1), create_node($2));}
      ;

func_call : VAR OB val_list CB {$$ = create_node(FUNC_CALL); add_child($$, 2 create_node($1), $3)}
          ;

val_list : expr {$$ = create_node(VAL_LIST); add_child($$, 1, $1);}
         | expr CM val_list {$$ = create_node(PAR_LIST); add_child($$, 1, $1); add_child($$, $3->children);}
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
