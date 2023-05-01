%option noyywrap
%{
#include "y.tab.h"
#include <string.h>
  int printfc =0;
  int scanfc =0;
  int count=0;
  int trycheck=0;
  int trycount=0;
  int linenumber=1;
%}
%s TRYSC
%s TRYMC
letter [a-zA-Z_]
digit [0-9]
integer [0]|[1-9][0-9]*
float ([0]|[1-9][0-9]*)\.[0-9]+([Ee][+-]?[0-9]+)?
character "'"."'"
string \"([^\"\\]|\\.)*\"
keywords auto|break|case|const|continue|default|do|double|else|enum|extern|goto|long|register|return|short|signed|sizeof|static|struct|typedef|union|unsigned|void|volatile
identifier  {letter}({letter}|{digit})*
%%
<INITIAL>"//" {BEGIN TRYSC;}
<TRYSC>. {}
<TRYSC>\n {BEGIN INITIAL;}
<INITIAL>"/*" {BEGIN TRYMC;}
<TRYMC>. {}
<TRYMC>\n {}
<TRYMC>"*/" {BEGIN INITIAL;}
<INITIAL>"int" return INT;
<INITIAL>"printf" return PRINT;
<INITIAL>"char" return CHAR;
<INITIAL>"float" return FLOAT;
<INITIAL>"if" return IF;
<INITIAL>"case" return CASE;
<INITIAL>"default" return DF;
<INITIAL>"while" return WHILE;
<INITIAL>"switch" return SW;
<INITIAL>"for" return FOR;
<INITIAL>"else" return ELSE;
<INITIAL>"void" return VOID;
<INITIAL>"break" return BREAK;
<INITIAL>"continue" return CONTINUE;
<INITIAL>"return" return RET;
<INITIAL>"+" return PL;
<INITIAL>"-" return MIN;
<INITIAL>"*" return MUL;
<INITIAL>"/" return DIV;
<INITIAL>"%" return MOD;
<INITIAL>"!" return NOT;
<INITIAL>"<" return LT;
<INITIAL>">" return GT;
<INITIAL>"&&" return AND;
<INITIAL>"||" return OR;
<INITIAL>"[" return OS;
<INITIAL>"]" return CS;
<INITIAL>"==" return DEQ;
<INITIAL>"!=" return NEQ;
<INITIAL>"<=" return LEQ;
<INITIAL>">=" return GEQ;
<INITIAL>"=" return EQ;
<INITIAL>"{" return OC;
<INITIAL>"}" return CC;
<INITIAL>"(" return OB;
<INITIAL>")" return CB;
<INITIAL>"," return CM;
<INITIAL>";" return SC;
<INITIAL>":" return CL;
<INITIAL>{string} {
  yylval.strval = malloc(sizeof(yytext)+5); 
 strcpy(yylval.strval, yytext);
    return STR;
}
<INITIAL>{keywords} {
  yylval.strval = malloc(sizeof(yytext)+5); 
 strcpy(yylval.strval, yytext);
    return KEYWORD;
}
<INITIAL>{identifier} {
    yylval.strval = malloc(sizeof(yytext)+5); 
 strcpy(yylval.strval, yytext);
 return VAR;
}
<INITIAL>{integer} {
      yylval.ival = atoi(yytext);
 return INTC;
}
<INITIAL>{character} {
   yylval.ch = yytext[0]; 
 return CHARC;
}
<INITIAL>{float} {
   yylval.fval = atof(yytext);
 return FLOATC;
}
<INITIAL>" " {}
\r {}
\t {}
\n {linenumber++;}
<<EOF>>  {return END;}
%%