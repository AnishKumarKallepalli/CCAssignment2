p : stmt_list
  ;

stmt_list : simple_stmt stmt_list
          | comp_stmt stmt_list
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

constant: INTC
| FLOATC
| CHARC
;

comp_stmt : OC stmt_list CC
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
         | VAR OS CS EQ expr
         | VAR OS expr CS OS expr CS EQ expr
         | VAR OS CS OS CS EQ expr
         ; 
asg_stmt : VAR EQ expr
         | VAR OS expr CS EQ expr
         | VAR OS CS EQ expr
         | VAR OS expr CS OS expr CS EQ expr
         | VAR OS expr CS OS CS EQ expr
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










if_stmt : IF OB expr CB stmt
        | IF OB expr CB stmt ELSE stmt 
        ;
while_stmt : WHILE OB expr CB stmt
           ;
for_stmt : FOR OB for_init SC expr SC asg_stmt CB stmt
         ;

for_init : decl_stmt
         | asg_stmt
         ;


iter_stmt : for_stmt
          | while_stmt
          ;
cntl_stmt : if_stmt
          | switch_list
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

jump_stmt : BREAK
          | CONTINUE
          | RET
          | RET expr 
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