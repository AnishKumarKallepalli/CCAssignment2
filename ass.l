%{
    #include "y.tab.h"
  int printfc =0;
  int scanfc =0;
%}
letter [a-zA-Z_]
digit [0-9]
operators [+\-*\/%=!<>&|~^?:]
punctuators [(){}[\].,;] 
keywords auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while
identifier  {letter}({letter}|{digit})*
%%
"printf" {printfc++;printf("%d",printfc);}
"scanf" {scanfc++;printf("%d",scanfc);}
{operators} {
    printf("OP\n");return OPERATOR;
}
{punctuators} {
   printf("PUN\n"); return PUNCTUATOR;
}

{keywords} {
    printf("KEY\n");return KEYWORD;
}
{identifier} {
 printf("IDEN\n",yytext);return IDENTIFIER;
}
[0-9]+ {
   printf("DIGIT\n"); return DIGIT;
}

\n return NL;
%%
