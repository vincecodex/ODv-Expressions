%{
  #include <stdlib.h>
  #include <stdio.h>
  #include <math.h>
  #include <string.h>
  #include "play.e.h"
  #include "y.tab.h"
  void yyerror(char *);
  char *endptr;
  int unary(union YYSTYPE*,int,char *);
  struct expression iliteral(long long i);
  struct expression fliteral(long double f);
  struct expression boperator(struct binary_operator_type *);
  struct expression uoperator(struct unary_operator_type *);
  struct expression boperatorc(struct binary_operator_type *,struct expression *,struct expression *);
  struct expression uoperatorc(struct unary_operator_type *,struct expression *);
%}

digit [0-9]
nonzerodigit [1-9]
hexidecimaldigit [0-9a-fA-F]
binarydigit [01]
octaldigit [0-7]
letter [a-zA-Z]
identifierchar [a-zA-Z_]
whitespace [ \t\n\r]
nonnewlinewhitespace [ \t]

%%

{nonnewlinewhitespace}+  {
      printf("lex skipped whitespace\n");
    }
\n+  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex found new lines\n");
      return NEW_LINES;
    }
0  {
      yylval.eValue = iliteral(0);
      printf("lex read 0\n");
      return INTEGER_LITERAL;
    }
0(b|B){binarydigit}*  {
      yylval.eValue = iliteral(strtol(yytext+2,&endptr,2));
      printf("lex read binary integer: %s -> %Ld (%s)\n",yytext,yylval.iValue,endptr);
      return INTEGER_LITERAL;
    }
0{octaldigit}*  {
      yylval.eValue = iliteral(strtol(yytext+1,&endptr,8));
      printf("lex read octal integer: %s -> %Ld (%s)\n",yytext,yylval.iValue,endptr);
      return INTEGER_LITERAL;
    }
{nonzerodigit}{digit}*  {
      yylval.eValue = iliteral(strtol(yytext,&endptr,10));
      printf("lex read decimal integer: %s -> %Ld (%s)\n",yytext,yylval.iValue,endptr);
      return INTEGER_LITERAL;
    }
0(x|X){hexidecimaldigit}*  {
      yylval.eValue = iliteral(strtol(yytext+2,&endptr,16));
      printf("lex read hexidecimal integer: %s -> %Ld (%s)\n",yytext,yylval.iValue,endptr);
      return INTEGER_LITERAL;
    }
"."{digit}+  {
      yylval.eValue = iliteral(strtod(yytext,&endptr));
      printf("lex read fraction: %s -> %Lf (%s)\n",yytext,yylval.fValue,endptr);
      return FLOAT_LITERAL;
    }
{digit}+"."{digit}*  {
      yylval.eValue = iliteral(strtod(yytext,&endptr));
      printf("lex read float: %s -> %Lf (%s)\n",yytext,yylval.fValue,endptr);
      return FLOAT_LITERAL;
    }
{identifierchar}+  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex read identifier: %s -> %s\n",yytext,yylval.sValue);
      return IDENTIFIER;
    }
"+"  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex read addition operator: %s\n",yytext);
      return OP_PL;
    }
"-"  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex read subtraction operator: %s\n",yytext);
      return OP_MI;
    }
"*"  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex read multiplication operator: %s\n",yytext);
      return OP_MU;
    }
"/"  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex read division operator: %s\n",yytext);
      return OP_DI;
    }
"**"  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex read exponentiation operator\n");
      return OP_EX;
    }
"("  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex read open parenthesis\n");
      return BR_OP;
    }
")"  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex read close parenthesis\n");
      return BR_CP;
    }
"|"  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex read abs symbol\n");
      return BR_AB;
    }
"|""^"  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex read open ceil symbol\n");
      return BR_OC;
    }
"^""|"  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex read close ceil symbol\n");
      return BR_CC;
    }
"|""_"  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex read open floor symbol\n");
      return BR_OF;
    }
"_""|"  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex read close floor symbol\n");
      return BR_CF;
    }
","  {
      yylval.sValue = malloc(yyleng+1);
      strcpy(yylval.sValue,yytext);
      printf("lex read comma symbol\n");
      return SP_CM;
    }
.  {
      yyerror("unrecognized character\n");
    }

%%

int unary(union YYSTYPE *yylval, int yyleng, char *yytext) {
  yylval->uValue.nom = malloc(yyleng+1);
  strcpy(yylval->uValue.nom,yytext);
  yylval->uValue.ptr = &sinl;
  printf("lex read sin function name\n");
  return UNARY_FUNCTION;
}

struct expression iliteral(long long i) {
  struct expression *literal;
  long long *l;
  literal = malloc(sizeof(struct expression));
  literal->type = EXPRESSION_TYPE_LITERAL_LONG_INTEGER;
  literal->data = l = malloc(sizeof(long long));
  *l = i;
  return literal;
}

struct expression fliteral(long double f) {
  struct expression *literal;
  long double *l;
  literal = malloc(sizeof(struct expression));
  literal->type = EXPRESSION_TYPE_LITERAL_LONG_DOUBLE;
  literal->data = l = malloc(sizeof(long double));
  *l = f;
  return literal;
}

struct expression boperatorc(struct binary_operator_type *b, struct expression *l, struct expression *r) {
  struct expression operator;
  struct binary_operator *o;
  operator.type = EXPRESSION_TYPE_BINARY_OPERATOR;
  operator.data = o = malloc(sizeof(struct binary_operator));
  o->type = b;
  o->left = l;
  o->right = r;
  return operator;
}

struct expression uoperatorc(struct unary_operator_type *u, struct expression *c) {
  struct expression operator;
  struct unary_operator *o;
  operator.type = EXPRESSION_TYPE_UNARY_OPERATOR;
  operator.data = o = malloc(sizeof(struct unary_operator));
  o->type = u;
  o->child = c;
  return operator;
}

struct expression boperator(struct binary_operator_type *b) {
  return boperatorc(b,0,0);
}

struct expression uoperator(struct unary_operator_type *u) {
  return uoperatorc(b,0);
}

int yywrap(void) {
  return 1;
}
