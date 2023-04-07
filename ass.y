%{
    #include <stdio.h>   
    #include <stdlib.h> 
%}

%token OPERATOR PUNCTUATOR KEYWORD IDENTIFIER DIGIT NL

%%
s:;
%%


void main(){
    printf("Enter expression: ");
    yyparse();
    exit(0);
}

void yyerror(){
    printf("error\n");
    exit(0);
}
