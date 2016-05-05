%{
  #include <stdio.h>
  #include <math.h>
  #include <string.h>
  #include <unistd.h>
  #include "play.e.h"
  int yylex(void);
  void yyerror(char *);
  long double lg(long double num);
  FILE *yyin, *yyout;
%}

%union {
  long long iValue;
  long double fValue;
  char *sValue;
  struct uval uValue;
  struct bval bValue;
};

%token <sValue> IDENTIFIER
%token <iValue> INTEGER_LITERAL
%token <fValue> FLOAT_LITERAL
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
%token <uValue> UNARY_FUNCTION
%token <bValue> BINARY_FUNCTION

%left OP_PL OP_MI
%left OP_MU OP_DI
%left OP_EX

%type <fValue> expression

%%

program:
    expression  { printf("%Lf\n",$1); }
    | program '\n' expression  { printf("%Lf\n",$3); }
    ;

expression:
    INTEGER_LITERAL  { $$ = $1; printf("found integer: %Ld\n",$1); }
    | FLOAT_LITERAL  { $$ = $1; printf("found integer: %Lf\n",$1); }
    | expression OP_PL expression  { $$ = $1 + $3; printf("found additive expression: %Lf + %Lf\n",$1,$3); }
    | expression OP_MI expression  { $$ = $1 - $3; printf("found subtractive expression: %Lf - %Lf\n",$1,$3); }
    | expression OP_MU expression  { $$ = $1 * $3; printf("found multiplicative expression: %Lf * %Lf\n",$1,$3); }
    | expression OP_DI expression  { $$ = $1 / $3; printf("found divisive expression: %Lf / %Lf\n",$1,$3); }
    | OP_MI expression  %prec OP_MU  { $$ = -$2; printf("found negative expression: -%Lf\n",$2); }
    | expression OP_EX expression  { $$ = powl( $1, $3 ); printf("found exponentiation expression: %Lf ^ %Lf\n",$1,$3); }
    | BR_OP expression BR_CP  { $$ = $2; printf("found parenthesized expression: %Lf\n",$2); }
    | UNARY_FUNCTION BR_OP expression BR_CP  { $$ = $1.ptr($3); printf("found unary function expression: %s(%Lf)\n",$1.nom,$3); }
    | BINARY_FUNCTION BR_OP expression SP_CM expression BR_CP  { $$ = $1.ptr($3,$5); printf("found binary function expression: %s(%Lf,%Lf)\n",$1.nom,$3,$5); }
    ;

%%

void yyerror(char *s) {
  fprintf(stderr, "%s\n", s);
}

#define MIN(a,b) ((a) < (b) ? (a) : (b))

int parse(char *str) {
  FILE *stream;
  int fd[2];
  int l, n;
  char *rem;
  
  printf("calling parse\n");
  
  if( pipe(fd) ) {
    printf("pipe() failed\n");
    return 1;
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
    return 0;
  }
}

int main(int argc, char *argv[]) {
  printf("main calls parse on \"%s\"\n",argv[1]);
  return parse(argv[1]);
}
