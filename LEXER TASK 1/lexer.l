%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h> 
  int linenumber=1;
%}
letter [a-zA-Z_]
digit [0-9]
integer [0]|[1-9][0-9]*
float ([0]|[1-9][0-9]*)\.[0-9]+([Ee][+-]?[0-9]+)?
character "'"."'"
duoperators ["==""!=""<="">=""||""&&"]
unoperators [+=\-*\/%!<>]
punctuators [(){}[\].,;] 
keywords float|char|int|auto|break|case|const|continue|default|do|double|else|enum|extern|goto|long|register|return|short|signed|sizeof|static|struct|typedef|union|unsigned|void|volatile
identifier  {letter}({letter}|{digit})*
%%
"==" {printf("%d\t\t\t\t%s\t\t\t\tOperator\n",linenumber,yytext);}
"!=" {printf("%d\t\t\t\t%s\t\t\t\tOperator\n",linenumber,yytext);}
"<=" {printf("%d\t\t\t\t%s\t\t\t\tOperator\n",linenumber,yytext);}
">=" {printf("%d\t\t\t\t%s\t\t\t\tOperator\n",linenumber,yytext);}
"||" {printf("%d\t\t\t\t%s\t\t\t\tOperator\n",linenumber,yytext);}
"&&" {printf("%d\t\t\t\t%s\t\t\t\tOperator\n",linenumber,yytext);}
{keywords} {
   printf("%d\t\t\t\t%s\t\t\t\tKeyword\n",linenumber,yytext);
}
{identifier} {
   printf("%d\t\t\t\t%s\t\t\t\tIdentifier\n",linenumber,yytext);
}
{integer} {
  printf("%d\t\t\t\t%s\t\t\t\tNumber\n",linenumber,yytext);
}
{character} {
   printf("%d\t\t\t\t%s\t\t\t\tNumber\n",linenumber,yytext);
}
{float} {
 printf("%d\t\t\t\t%s\t\t\t\tNumber\n",linenumber,yytext);
}
{unoperators} {
  printf("%d\t\t\t\t%s\t\t\t\tOperator\n",linenumber,yytext);
}
{punctuators} {
  printf("%d\t\t\t\t%s\t\t\t\tPunctuators\n",linenumber,yytext);
}
" " {}
\n {linenumber++;}
%%
int main()
{
    yyin = fopen("input.txt","r");
    printf("Linenumber\t\t\tLexeme\t\t\t\tToken type\n\n");
    yylex();
    return 0 ;
}