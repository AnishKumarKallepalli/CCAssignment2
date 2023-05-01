%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
 int printfc =0;
  int scanfc =0;
  int count=0;
  int trycheck=0;
  int trycount=0;
  int linenumber=1; 
  int arr[100];
  int arr2[100];
  int i=0;
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
unoperators [+=\-*\/%!<>]
punctuators [(){}[\].,;] 
keywords float|char|int|auto|break|case|const|continue|default|do|double|else|enum|extern|goto|long|register|return|short|signed|sizeof|static|struct|typedef|union|unsigned|void|volatile
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
<TRYP>")" {arr[i]=0;arr2[i]=linenumber;i++;count=0;trycount=0;trycheck=0;BEGIN INITIAL;}
<TRYP>. {arr[i]=0;arr2[i]=linenumber;i++; count=0;trycount=0;trycheck=0;BEGIN TEMP;}
<CHECKP>")" {if(trycount==count&&trycheck==1){count=0;trycount=0;trycheck=0;printfc++;BEGIN INITIAL;}else{arr[i]=0;arr2[i]=linenumber;i++;count=0;trycount=0;trycheck=0; BEGIN INITIAL;}}
<CHECKP>" " {}
<CHECKP>. {arr[i]=0;arr2[i]=linenumber;i++; count=0;trycount=0;trycheck=0;BEGIN TEMP;}
<TEMP>")" {BEGIN INITIAL;}
<TEMP>. {}
<INITIAL>"scanf(\"" {BEGIN SCANCHECK;}
<SCANCHECK>"%d" {count++;trycheck=1;}
<SCANCHECK>"%c" {count++;trycheck=1;}
<SCANCHECK>"%f" {count++;trycheck=1;}
<SCANCHECK>"\"" {BEGIN CHECKS;}
<SCANCHECK>" " {}
<SCANCHECK>. {arr[i]=1;arr2[i]=linenumber;i++; count=0;trycount=0;trycheck=0;BEGIN TEMP;}
<CHECKS>"," {trycount++;BEGIN TRYS;}
<TRYS>{and_check}{identifier} {BEGIN CHECKS;}
<TRYS>" " {}
<TRYS>")" {arr[i]=1;arr2[i]=linenumber;i++;count=0;trycount=0;trycheck=0;BEGIN INITIAL;}
<TRYS>. {arr[i]=1;arr2[i]=linenumber;i++; count=0;trycount=0;trycheck=0;BEGIN TEMP;}
<CHECKS>")" {if(trycount==count&&trycheck==1){count=0;trycount=0;scanfc++;trycheck=0;BEGIN INITIAL;}else{arr[i]=1;arr2[i]=linenumber;i++;count=0;trycount=0;trycheck=0; BEGIN INITIAL;}}
<CHECKS>" " {}
<CHECKS>. {arr[i]=1;arr2[i]=linenumber;i++;count=0;trycount=0;trycheck=0; BEGIN TEMP;}
<INITIAL>"==" {printf("%d\t\t\t\t%s\t\t\t\tOperator\n",linenumber,yytext);}
<INITIAL>"!=" {printf("%d\t\t\t\t%s\t\t\t\tOperator\n",linenumber,yytext);}
<INITIAL>"<=" {printf("%d\t\t\t\t%s\t\t\t\tOperator\n",linenumber,yytext);}
<INITIAL>">=" {printf("%d\t\t\t\t%s\t\t\t\tOperator\n",linenumber,yytext);}
<INITIAL>"||" {printf("%d\t\t\t\t%s\t\t\t\tOperator\n",linenumber,yytext);}
<INITIAL>"&&" {printf("%d\t\t\t\t%s\t\t\t\tOperator\n",linenumber,yytext);}
<INITIAL>{keywords} {
   printf("%d\t\t\t\t%s\t\t\t\tKeyword\n",linenumber,yytext);
}
<INITIAL>{identifier} {
   printf("%d\t\t\t\t%s\t\t\t\tIdentifier\n",linenumber,yytext);
}
<INITIAL>{integer} {
  printf("%d\t\t\t\t%s\t\t\t\tNumber\n",linenumber,yytext);
}
<INITIAL>{character} {
   printf("%d\t\t\t\t%s\t\t\t\tNumber\n",linenumber,yytext);
}
<INITIAL>{float} {
 printf("%d\t\t\t\t%s\t\t\t\tNumber\n",linenumber,yytext);
}
<INITIAL>{unoperators} {
  printf("%d\t\t\t\t%s\t\t\t\tOperator\n",linenumber,yytext);
}
<INITIAL>{punctuators} {
  printf("%d\t\t\t\t%s\t\t\t\tPunctuator\n",linenumber,yytext);
}
<INITIAL>" " {}
\r {}
\t {}
\n {linenumber++;}
<<EOF>>  {printf("Number of valid printf statement: %d\n",printfc);printf("Number of valid scanf statement: %d\n",scanfc); return 0;}
%%
int main()
{
    yyin = fopen("input.txt","r");
    printf("Linenumber\t\t\tLexeme\t\t\t\tToken type\n\n");
    yylex();
    for(int j=0;j<i;j++)
    {
      if(arr[j]==0)
      printf("Invalid printf statement on line number: %d\n",arr2[j]);
      else if(arr[j]==1)
      printf("Invalid scanf statement on line number: %d\n",arr2[j]);
    }
    return 0 ;
}