all: test

test: build test.001.out

test.000.out: test.000 eparse
	./eparse "`cat test.000`" > test.000.out

test.001.out: test.001 eparse
	./eparse "`cat test.001`" > test.001.out

build: eparse

eparse: play.e.h play.e.c lex.yy.c y.tab.c
	gcc play.e.c lex.yy.c y.tab.c -lm -o eparse

y.tab.c: e.y
	yacc -d e.y

lex.yy.c: e.lex
	flex e.lex

clean:
	rm y.tab.h y.tab.c lex.yy.c eparse test.*.out
