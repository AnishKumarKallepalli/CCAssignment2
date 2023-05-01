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
%s PRINTCHECK 
%s CHECKP
%s CHECKS
%s TRYP
%s TRYS
%s SCANCHECK 
%s TEMP
letter [a-zA-Z_]
digit [0-9]
and_check [&]
integer [0]|[1-9][0-9]*
float ([0]|[1-9][0-9]*)\.[0-9]+([Ee][+-]?[0-9]+)?
character "'"."'"
punctuators [(){}[\].,] 
keywords auto|break|case|const|continue|default|do|double|else|enum|extern|goto|long|register|return|short|signed|sizeof|static|struct|typedef|union|unsigned|void|volatile
identifier  {letter}({letter}|{digit})*
%%
<INITIAL>"printf(\"" {BEGIN PRINTCHECK;}
<PRINTCHECK>"%d" {count++;trycheck=1;}
<PRINTCHECK>"%c" {count++;trycheck=1;}
<PRINTCHECK>"%f" {count++;trycheck=1;}
<PRINTCHECK>"\"" {BEGIN CHECKP;}
<PRINTCHECK>. {trycheck=1;}
<CHECKP>"," {trycount++;BEGIN TRYP;}
<TRYP>{identifier} {BEGIN CHECKP;}
<TRYP>" " {}
<TRYP>")" {printf("Invalid printf statement on line number: %d\n",linenumber);count=0;trycount=0;trycheck=0;BEGIN INITIAL;}
<TRYP>. {printf("Invalid printf statement on line number: %d\n",linenumber); count=0;trycount=0;trycheck=0;BEGIN TEMP;}
<CHECKP>")" {if(trycount==count&&trycheck==1){count=0;trycount=0;trycheck=0;printfc++;BEGIN INITIAL;}else{printf("Invalid printf statement on line number: %d\n",linenumber);count=0;trycount=0;trycheck=0; BEGIN INITIAL;}}
<CHECKP>" " {}
<CHECKP>. {printf("Invalid printf statement on line number: %d\n",linenumber); count=0;trycount=0;trycheck=0;BEGIN TEMP;}
<TEMP>")" {BEGIN INITIAL;}
<TEMP>. {}
<INITIAL>"scanf(\"" {BEGIN SCANCHECK;}
<SCANCHECK>"%d" {count++;trycheck=1;}
<SCANCHECK>"%c" {count++;trycheck=1;}
<SCANCHECK>"%f" {count++;trycheck=1;}
<SCANCHECK>"\"" {BEGIN CHECKS;}
<SCANCHECK>" " {}
<SCANCHECK>. {printf("Invalid scanf statement on line number: %d\n",linenumber); count=0;trycount=0;trycheck=0;BEGIN TEMP;}
<CHECKS>"," {trycount++;BEGIN TRYS;}
<TRYS>{and_check}{identifier} {BEGIN CHECKS;}
<TRYS>" " {}
<TRYS>")" {printf("Invalid printf statement on line number: %d\n",linenumber);count=0;trycount=0;trycheck=0;BEGIN INITIAL;}
<TRYS>. {printf("Invalid scanf statement on line number: %d\n",linenumber); count=0;trycount=0;trycheck=0;BEGIN TEMP;}
<CHECKS>")" {if(trycount==count&&trycheck==1){count=0;trycount=0;scanfc++;trycheck=0;BEGIN INITIAL;}else{printf("Invalid scanf statement on line number: %d\n",linenumber);count=0;trycount=0;trycheck=0; BEGIN INITIAL;}}
<CHECKS>" " {}
<CHECKS>. {printf("Invalid scanf statement on line number: %d\n",linenumber);count=0;trycount=0;trycheck=0; BEGIN TEMP;}
<INITIAL>"int" return INT;
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
\n {linenumber++;}
<<EOF>>  {printf("Number of valid printf statement %d\n",printfc);printf("Number of valid scanf statement %d\n",scanfc); return 0;}
%%
