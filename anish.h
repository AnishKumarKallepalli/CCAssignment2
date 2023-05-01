//assignment statements for arrays must have row and column
// not handling else-if
// function has to return

s: global_statement s
| func_def s
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
          | VAR OS expr CS
          | VAR OS expr CS OS expr CS
          | VAR OS expr CS OS CS
          | VAR EQ expr
          ;

assign_stmt : VAR EQ expr_stmt
         | VAR OS expr_stmt CS EQ expr_stmt
         | VAR OS expr_stmt CS OS expr_stmt CS EQ expr_stmt
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

global_statement: decl_stmt SC
;

jump_stmt :| RET
          | RET expr_stmt
          ;

func_def : ret_type VAR OB param_list CB comp_stmt
         ;

ret_type : TYPE | VOID
         ;

param_list : TYPE VAR
           | TYPE VAR CM param_list
           ;

func_call : VAR OB val_list CB
          ;

val_list : expr 
         | expr CM val_list
         ;