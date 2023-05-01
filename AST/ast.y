    %{
        #include <stdio.h>   
        #include <stdlib.h> 
        #include "ast.h"
        #include "constants.h"
        extern FILE *yyin;
        char curr_type[100];
    %}
    //for loop for later , even arrays and functions for later
    //assuming while has only expression and not assignment in grammer
    // if and else is only there...no elseif and if needs statements in curly braces
    //syntax error 0 means semicolon missing and 1 is for bracket
%union {char *strval; int ival; char ch; float fval; ASTNode* ast;}
%token <strval> INTC <strval> VAR <strval> CHARC <strval> FLOATC <strval> STR
%token PL MIN MUL DIV MOD NOT LT GT EQ AND OR SC CM OB CB OC CC IF WHILE SW FOR ELSE CL CASE DF OS CS VOID BREAK CONTINUE RET DEQ NEQ LEQ GEQ
%token INT CHAR FLOAT KEYWORD END PRINT 
%type <ast> dec_spec <ast> jump_stmt <ast> constant <ast> add_expr <ast> mul_expr <ast> rel_expr <ast>equ_expr <ast>log_or_expr <ast>log_and_expr <ast>arg_expr_list <ast>prim_expr <ast>postfix_expr <ast>unary_op <ast>unary_expr <ast>asg_expr expr  <ast>expr_stmt  <ast>id_list  <ast>param_list  <ast>init_list  <ast>init_dec  <ast>type_spec  <ast>declaration  <ast>iter_stmt  <ast>comp_stmt  <ast>lab_stat  <ast>sel_stmt  <ast>declarator  <ast>func_list  <ast>func_defn  <ast>stmt_list  <ast>stmt
    
    %%
     
    p : func_list END { printf("Parse done"); print_syntax_tree($1); return 1;}
      ;
     
    func_list : func_defn {$$ = create_node(FUNC_LIST); add_child($$, 1, $1); }
              | func_list func_defn {$$ = create_node(FUNC_LIST); add_children($$, $1); add_child($$, 1, $2);}
              ;
     
    func_defn : dec_spec declarator comp_stmt {$$ = create_node(F_DEF); add_child($$, 1, $1); add_children($$, $2); add_child($$, 1, $3);}
              ;
              
    stmt_list : stmt {$$ = create_node(ST_LIST); add_child($$, 1, $1);}
              | stmt_list stmt {$$ = create_node(ST_LIST); add_children($$, $1); add_child($$, 1, $2);}
              ;
     
     
    stmt : lab_stat {$$ = $1;}
         | expr_stmt {$$ = $1;}
         | comp_stmt {$$ = $1;}
         | sel_stmt {$$ = $1;}
         | iter_stmt {$$ = $1;}
         | jump_stmt {$$ = $1;}
         | declaration {$$ = $1;}
         | print_stmt {$$ = $1;}
         ;
     
    lab_stat
    	: CASE  log_or_expr CL stmt {$$ = NULL;}
    	| DF CL stmt {$$ = NULL;}
    	;
     
    sel_stmt : IF OB expr CB stmt {$$ = create_node("if"); add_child($$, 2, $3, $5);}
             | IF OB expr CB stmt ELSE stmt {$$ = create_node("if"); add_child($$, 3, $3, $5, $7);}
             | SW OB expr CB stmt {$$ = create_node("switch"); add_child($$, 2, $3, $5);}
             ;
      
    comp_stmt : OC CC {$$ = NULL;}
              | OC stmt_list CC {$$ = create_node(COMP_ST); add_children($$, $2);}
              ;
     
    iter_stmt : WHILE OB expr CB stmt {$$ = create_node("while"); add_child($$, 2, $3, $5);}
              | FOR OB expr_stmt expr_stmt CB stmt {$$ = create_node("for"); add_child($$, 4, NULL, $3, $4, $6);}
              | FOR OB expr_stmt expr_stmt expr CB stmt {$$ = create_node("for"); add_child($$, 4, $3, $4, $5, $7);}
              | FOR OB declaration expr_stmt CB stmt {$$ = create_node("for"); add_child($$, 4, $3, $4, NULL, $6);}
              | FOR OB declaration expr_stmt expr CB stmt {$$ = create_node("for"); add_child($$, 4, $3, $4, $5, $7);}
              ;
     
    jump_stmt : BREAK {$$ = create_node("break");}
              | CONTINUE {$$ = create_node("continue");}
              | RET expr SC {$$ = create_node("return"); add_child($$, 1, $2);}
              ;
     
    declaration : dec_spec init_list SC {$$ = create_node(DECL); add_child($$, 1, $1); add_children($$, $2);}
                ;
    dec_spec : type_spec {$$ = $1;}
             ;
     
    type_spec : VOID {$$ = create_node("void");}
              | INT {$$ = create_node("int");}
              | CHAR {$$ = create_node("char");}
              | FLOAT {$$ = create_node("float");}
              ;
     
    init_list : init_dec {$$ = create_node(INIT_LIST); add_child($$, 1, $1);}
              | init_list CM init_dec {$$ = create_node(INIT_LIST); add_children($$, $3); add_child($$, 1, $1);}
              ;
     
    init_dec : declarator {$$ = $1;}
             | declarator EQ asg_expr {$$ = create_node("="); add_child($$, 2, $1, $3);}
             ;
     
    declarator : VAR {$$ = create_node($1);}
               | VAR OS expr CS {$$ = create_node(ARR); add_child($$, 2, $1, $3);}
    		       | VAR OS expr CS OS expr CS {$$ = create_node(ARR); add_child($$, 3, $1, $3, $6);}
    		       | VAR OB param_list CB {$$ = create_node(DECLARATOR); add_child($$, 2, $1, $3);}      
               | VAR OB CB {$$ = create_node(DECLARATOR); add_child($$, 2, $1, create_node(P_LIST));}
               ;
     
    param_list : dec_spec declarator {$$ = create_node(P_LIST); ASTNode *temp = create_node(PARAM); add_child(temp, 2, $1, $2); add_child($$, 1, temp);}
               | param_list CM dec_spec declarator {$$ = create_node(P_LIST);  add_children($$, $1); ASTNode *temp = create_node(PARAM); add_child(temp, 2, $3, $4); add_child($$, 1, temp);}
               ;
     
    id_list : VAR {$$ = create_node(ID_LIST); add_child($$, 1, $1);}
            | id_list CM VAR {$$ = create_node(ID_LIST); add_children($$, $1); add_child($$, 1, create_node($3));}
            ;
     
    expr_stmt : SC
              | expr SC {$$ = $1;}
              ;
     
    expr : asg_expr {$$ = $1;}
         ;
     
    asg_expr : log_or_expr {$$ = $1;}
             | unary_expr EQ asg_expr {$$ = create_node("="); add_child($$, 2, $1, $3);}
             ;
     
    unary_expr : postfix_expr {$$ = $1;}
               | unary_op unary_expr {$$ = $1; add_child($$, 1, $2);}
               ;
     
    unary_op : MIN {$$ = create_node(U_MIN);}
             | NOT {$$ = create_node("!");}
             ; 
     
    postfix_expr : prim_expr {$$ = $1;}
                | postfix_expr OS expr CS {$$ = create_node(ARR); add_child($$, 2, $1, $3);}
                | postfix_expr OB CB {$$ = create_node(F_CALL); add_child($$, 1, $1);}
                | postfix_expr OB arg_expr_list CB {$$ = create_node(F_CALL); add_child($$, 1, $1); add_children($$, $3);}
                ;
     
    prim_expr : VAR {$$ = create_node($1);}
              | constant {$$ = $1;}
              | OB expr CB {$$ = $2;}
              ;
     
    arg_expr_list : asg_expr {$$ = $1;}
                  | arg_expr_list CM asg_expr {$$ = create_node(EXPR_LIST); add_children($$, $1); add_child($$, 1, $1);}
                  ;
     
    log_or_expr : log_and_expr {$$ = $1;}
                | log_or_expr OR log_and_expr {$$ = create_node("||"); add_child($$, 2, $1, $3);}
                ;
     
    log_and_expr : equ_expr {$$ = $1;}
                 | log_and_expr AND equ_expr {$$ = create_node("&&"); add_child($$, 2, $1, $3);}
                 ;
     
    equ_expr : rel_expr {$$ = $1;}
             | equ_expr DEQ rel_expr {$$ = create_node("=="); add_child($$, 2, $1, $3);}
             | equ_expr NEQ rel_expr {$$ = create_node("!="); add_child($$, 2, $1, $3);}
             ;
     
    rel_expr : add_expr {$$ = $1;}
             | rel_expr LT add_expr {$$ = create_node("<"); add_child($$, 2, $1, $3);}
             | rel_expr GT add_expr {$$ = create_node(">"); add_child($$, 2, $1, $3);}
             | rel_expr LEQ add_expr {$$ = create_node("<="); add_child($$, 2, $1, $3);}
             | rel_expr GEQ add_expr {$$ = create_node(">="); add_child($$, 2, $1, $3);}
             ;
     
    add_expr : mul_expr {$$ = $1;}
             | add_expr PL mul_expr {$$ = create_node("+"); add_child($$, 2, $1, $3);}
             | add_expr MIN mul_expr {$$ = create_node("-"); add_child($$, 2, $1, $3);}
             ;
     
    mul_expr : unary_expr {$$ = $1;}
             | mul_expr MUL unary_expr {$$ = create_node("*"); add_child($$, 2, $1, $3);}
             | mul_expr DIV unary_expr {$$ = create_node("/"); add_child($$, 2, $1, $3);}
             | mul_expr MOD unary_expr {$$ = create_node("%"); add_child($$, 2, $1, $3);}
             ;
     
    constant: INTC {$$ = create_node($1);}
    | FLOATC {$$ = create_node($1);}
    | CHARC {$$ = create_node($1);}
    ;

    print_stmt : PRINT OB STR CB SC
               | PRINT OB STR CM id_list CB SC
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