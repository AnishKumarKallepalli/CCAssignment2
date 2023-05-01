#!bin/bash
rm lex.yy.c y.tab.c a.out
yacc -dy temp.y
flex ast.l
gcc y.tab.c lex.yy.c -ll -g
./a.out < input.txt > syntaxtree.txt