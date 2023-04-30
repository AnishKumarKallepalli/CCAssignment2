%option noyywrap
%{
#include "y.tab.h"
#include <string.h>
  int printfc =0;
  int scanfc =0;
  int count=0;
  int trycheck=0;
  int trycount=0;
%}
%s PRINTCHECK 
%s CHECKP
%s CHECKS
%s TRYP
%s TRYS
%s SCANCHECK 
letter [a-zA-Z_]
digit [0-9]
and_check [&]
integer [0]|[1-9][0-9]*
float ([0]|[1-9][0-9]*)\.[0-9]+([Ee][+-]?[0-9]+)?
character "'"."'"
punctuators [(){}[\].,] 
keywords auto|break|case|const|continue|default|do|double|else|enum|extern|goto|long|register|return|short|signed|sizeof|static|struct|typedef|union|unsigned|void|volatile
identifier  {letter}({letter}|{digit})*
types float|char|int
%%

"printf(\"" {BEGIN PRINTCHECK;}
<PRINTCHECK>"%d" {count++;trycheck=1;}
<PRINTCHECK>"%c" {count++;trycheck=1;}
<PRINTCHECK>"%f" {count++;trycheck=1;}
<PRINTCHECK>"\"" {BEGIN CHECKP;}
<PRINTCHECK>. {trycheck=1;}
<CHECKP>"," {trycount++;BEGIN TRYP;}
<TRYP>{identifier} {BEGIN CHECKP;}
<TRYP>" " {}
<TRYP>. {printf("Invalid printf statement\n"); exit(0);}
<CHECKP>")" {if(trycount==count&&trycheck==1){count=0;trycount=0;printfc++;trycheck=0;BEGIN INITIAL;}else{printf("Invalid printf statement\n"); exit(0);}}
<CHECKP>" " {}
<CHECKP>. {printf("Invalid printf statement\n"); exit(0);}


"scanf(\"" {BEGIN SCANCHECK;}
<SCANCHECK>"%d" {count++;trycheck=1;}
<SCANCHECK>"%c" {count++;trycheck=1;}
<SCANCHECK>"%f" {count++;trycheck=1;}
<SCANCHECK>"\"" {BEGIN CHECKS;}
<SCANCHECK>" " {}
<SCANCHECK>. {printf("Invalid scanf statement\n"); exit(0);}
<CHECKS>"," {trycount++;BEGIN TRYS;}
<TRYS>{and_check}{identifier} {BEGIN CHECKS;}
<TRYS>" " {}
<TRYS>. {printf("Invalid scanf statement\n"); exit(0);}
<CHECKS>")" {if(trycount==count&&trycheck==1){count=0;trycount=0;scanfc++;trycheck=0;BEGIN INITIAL;}else{printf("Invalid scanf statement\n"); exit(0);}}
<CHECKS>" " {}
<CHECKS>. {printf("Invalid scanf statement\n"); exit(0);}
"if" return IF;
"case" return CASE;
"default" return DF;
"while" return WHILE;
"switch" return SW;
"for" return FOR;
"else" return ELSE;
"void" return VOID;
"break" return BREAK;
"continue" return CONTINUE;
"return" return RET;
"+" return PL;
"-" return MIN;
"*" return MUL;
"/" return DIV;
"%" return MOD;
"!" return NOT;
"<" return LT;
">" return GT;
"&&" return AND;
"||" return OR;
"[" return OS;
"]" return CS;
"=" return EQ;
"{" return OC;
"}" return CC;
"(" return OB;
")" return CB;
"," return CM;
";" return SC;
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
{punctuators} {
  yylval.ch = yytext[0];
   return PUNCTUATOR;
}
\n return NL;
<<EOF>>  {printf("Number of valid printf statement %d\n",printfc);printf("Number of valid scanf statement %d\n",scanfc); return 0;}
%%
