%{
  #include <stdlib.h>
  #include <stdio.h>
  #include <math.h>
  #include <string.h>
  #include <unistd.h>
  #include "play.e.h"
  int yylex(void);
  void yyerror(char *);
  long double lg(long double num);
  FILE *yyin, *yyout;
  struct expression *output;
  struct expression *boperator(struct binary_operator_type *);
  struct expression *uoperator(struct unary_operator_type *);
  struct expression *boperatorc(struct binary_operator_type *,struct expression *,struct expression *);
  struct expression *uoperatorc(struct unary_operator_type *,struct expression *);
%}

%union {
  long long iValue;
  long double fValue;
  char *sValue;
  struct unary_operator_type *uValue;
  struct binary_operator_type *bValue;
  struct expression *eValue;
};

%token <eValue> IDENTIFIER
%token <eValue> INTEGER_LITERAL
%token <eValue> FLOAT_LITERAL
%token <sValue> OP_PL
%token <sValue> OP_MI
%token <sValue> OP_MU
%token <sValue> OP_DI
%token <sValue> OP_EX
%token <sValue> BR_OP
%token <sValue> BR_CP
%token <sValue> BR_AB
%token <sValue> BR_OC
%token <sValue> BR_CC
%token <sValue> BR_OF
%token <sValue> BR_CF
%token <sValue> SP_CM
%token <sValue> NEW_LINES
%token <uValue> UNARY_FUNCTION
%token <bValue> BINARY_FUNCTION

%left OP_PL OP_MI
%left OP_MU OP_DI
%left OP_EX

%type <eValue> expression

%%

program:
    expression  { output = $1; printf("expression parsed\n"); }
    | program NEW_LINES expression  { output = $3; printf("expression parsed\n"); }
    ;

expression:
    INTEGER_LITERAL  { $$ = $1; printf("found integer\n"); }
    | FLOAT_LITERAL  { $$ = $1; printf("found float\n"); }
    | expression OP_PL expression  { $$ = boperatorc(&BIN_OP_ADDITION,$1,$3); printf("found additive expression\n"); }
    | expression OP_MI expression  { $$ = boperatorc(&BIN_OP_SUBTRACTION,$1,$3); printf("found subtractive expression\n"); }
    | expression OP_MU expression  { $$ = boperatorc(&BIN_OP_MULTIPLICATION,$1,$3); printf("found multiplicative expression\n"); }
    | expression OP_DI expression  { $$ = boperatorc(&BIN_OP_DIVISION,$1,$3); printf("found divisive expression\n"); }
    | OP_MI expression  %prec OP_MU  { $$ = uoperatorc(&UN_OP_NEGATION,$2); printf("found negative expression\n"); }
    | expression OP_EX expression  { $$ = boperatorc(&BIN_OP_EXPONENTIATION,$1,$3); printf("found exponentiation expression\n"); }
    | BR_OP expression BR_CP  { $$ = $2; printf("found parenthesized expression\n"); }
    | BR_AB expression BR_AB  { $$ = uoperatorc(&UN_OP_ABSOLUTE,$2); printf("found abs expression\n"); }
    | BR_OC expression BR_CC  { $$ = uoperatorc(&UN_OP_CEILING,$2); printf("found ceil expression\n"); }
    | BR_OF expression BR_CF  { $$ = uoperatorc(&UN_OP_FLOOR,$2); printf("found floor expression\n"); }
    ;

%%

void yyerror(char *s) {
  fprintf(stderr, "%s\n", s);
}

struct expression *boperatorc(struct binary_operator_type *b, struct expression *l, struct expression *r) {
  struct expression *operator;
  struct binary_operator *o;
  operator = malloc(sizeof(struct expression));
  operator->type = EXPRESSION_TYPE_BINARY_OPERATOR;
  o = malloc(sizeof(struct binary_operator));
  operator->data = (char *) o;
  o->type = b;
  o->left = l;
  o->right = r;
  return operator;
}

struct expression *uoperatorc(struct unary_operator_type *u, struct expression *c) {
  struct expression *operator;
  struct unary_operator *o;
  operator = malloc(sizeof(struct expression));
  operator->type = EXPRESSION_TYPE_UNARY_OPERATOR;
  o = malloc(sizeof(struct unary_operator));;
  operator->data = (char *) o;
  o->type = u;
  o->child = c;
  return operator;
}

struct expression *boperator(struct binary_operator_type *b) {
  return boperatorc(b,0,0);
}

struct expression *uoperator(struct unary_operator_type *u) {
  return uoperatorc(u,0);
}

#define MIN(a,b) ((a) < (b) ? (a) : (b))

struct expression *parse(char *str) {
  FILE *stream;
  int fd[2];
  int l, n;
  char *rem;
  
  printf("calling parse\n");
  
  if( pipe(fd) ) {
    printf("pipe() failed\n");
    return 0;
  }
  else {
    yyin = fdopen(fd[0], "r");
    stream = fdopen(fd[1], "w");
    l = strlen(str);
    rem = str;
//*
    while( l > 0 ) {
      n = fwrite(rem,1,MIN(l,1024),stream);
      l -= n;
      rem += n;
    }
    fclose(stream);
    yyparse();
//*/
    return output;
  }
}

int main(int argc, char *argv[]) {
  struct expression *e;
  printf("main calls parse on \"%s\"\n",argv[1]);
  e = parse(argv[1]);
  print_tree(e);
  return 0;
}
