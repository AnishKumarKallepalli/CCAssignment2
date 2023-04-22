%option noyywrap
%{
#include "y.tab.h"
#include <string.h>
  int printfc =0;
  int scanfc =0;
%}
letter [a-zA-Z_]
digit [0-9]
integer [0]|[1-9][0-9]*
float ([0]|[1-9][0-9]*)\.[0-9]+([Ee][+-]?[0-9]+)?
character "'"."'"
operators [+\-*\/%!<>"==""||""&&"]
punctuators [(){}[\].,] 
keywords auto|break|case|const|continue|default|do|double|else|enum|extern|goto|long|register|return|short|signed|sizeof|static|struct|typedef|union|unsigned|void|volatile
identifier  {letter}({letter}|{digit})*
types float|char|int
%%
"printf" {printfc++;printf("Number of Printf currently are %d",printfc);}
"scanf" {scanfc++;printf("Number of Scanf currently are %d",scanfc);}

"if" return IF;
"case" return CASE;
"default" return DF;
"while" return WH;
"switch" return SW;
"for" return FR;
"else" return ELSE;
"=" return EQ;
"{" return OC;
"}" return CC;
"(" return OB;
")" return CB;
"," return CM;
";" {return SC;}
":" return CL;
{types} {
  yylval.strval = malloc(sizeof(yytext)+5); 
 strcpy(yylval.strval, yytext);
 return TYPE;
}
{keywords} {
  yylval.strval = malloc(sizeof(yytext)+5); 
 strcpy(yylval.strval, yytext);
    return KEYWORD;
}
{identifier} {
    yylval.strval = malloc(sizeof(yytext)+5); 
 strcpy(yylval.strval, yytext);
 return IDENTIFIER;
}
{integer} {
      yylval.ival = atoi(yytext);
 return INTEGER;
}
{character} {
   yylval.strval = malloc(sizeof(yytext)+5); 
 strcpy(yylval.strval, yytext);
 return CHARACTER;
}
{float} {
 return FLOAT;
}
{operators} {
  yylval.ch = yytext[0];
    return OPERATOR;
}
{punctuators} {
  yylval.ch = yytext[0];
   return PUNCTUATOR;
}
\n return NL;
%%
