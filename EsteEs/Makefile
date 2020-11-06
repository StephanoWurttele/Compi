all: lex
	gcc -o a.out lex.yy.c y.tab.c

debug: lex
	gcc -o debug.out -DYYDEBUG lex.yy.c y.tab.c


lex: yacc
	lex calc.l

yacc:
	yacc -d calc.y
	
clean:
	rm y.* *.out lex.yy.c

