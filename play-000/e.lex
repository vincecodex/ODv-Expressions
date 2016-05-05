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

sin  {
      return unary(&yylval,yyleng,yytext);
    }
sine  {
      return unary(&yylval,yyleng,yytext);
    }
cos(ine)?  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &cosl;
      printf("lex read cos function name\n");
      return UNARY_FUNCTION;
    }
tan(gent)?  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &tanl;
      printf("lex read tan function name\n");
      return UNARY_FUNCTION;
    }
a(rc_?)?sine?  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &asinl;
      printf("lex read asin function name\n");
      return UNARY_FUNCTION;
    }
a(rc_?)?cos(ine)?  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &acosl;
      printf("lex read acos function name\n");
      return UNARY_FUNCTION;
    }
a(rc_?)?tan(gent)?  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &atanl;
      printf("lex read atan function name\n");
      return UNARY_FUNCTION;
    }
(hyperbolic_?)?sine?|sinh  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &sinhl;
      printf("lex read sinh function name\n");
      return UNARY_FUNCTION;
    }
(hyperbolic_?)?cos(ine)?|cosh  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &coshl;
      printf("lex read cosh function name\n");
      return UNARY_FUNCTION;
    }
(hyperbolic_?)?tan(gent)?|tanh  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &tanhl;
      printf("lex read tanh function name\n");
      return UNARY_FUNCTION;
    }
(hyperbolic_?)?a(rc_?)?sine?|asinh  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &asinhl;
      printf("lex read asinh function name\n");
      return UNARY_FUNCTION;
    }
(hyperbolic_?)?a(rc_?)?cos(ine)?|acosh  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &acoshl;
      printf("lex read acosh function name\n");
      return UNARY_FUNCTION;
    }
(hyperbolic_?)?a(rc_?)?tan(gent)?|atanh  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &atanhl;
      printf("lex read atanh function name\n");
      return UNARY_FUNCTION;
    }
exp  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &expl;
      printf("lex read exp function name\n");
      return UNARY_FUNCTION;
    }
lg|log2  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &lg;
      printf("lex read lg function name\n");
      return UNARY_FUNCTION;
    }
ln|log(e|E)|natural_?log  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &logl;
      printf("lex read ln function name\n");
      return UNARY_FUNCTION;
    }
log|log10  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &log10l;
      printf("lex read log function name\n");
      return UNARY_FUNCTION;
    }
sqrt|square_?root  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &sqrtl;
      printf("lex read sqrt function name\n");
      return UNARY_FUNCTION;
    }
ceil(ing)?  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &ceill;
      printf("lex read ceil function name\n");
      return UNARY_FUNCTION;
    }
floor  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &floorl;
      printf("lex read floor function name\n");
      return UNARY_FUNCTION;
    }
abs  {
      yylval.uValue.nom = malloc(yyleng+1);
      strcpy(yylval.uValue.nom,yytext);
      yylval.uValue.ptr = &fabsl;
      printf("lex read abs function name\n");
      return UNARY_FUNCTION;
    }
{whitespace}+  {
      printf("lex skipped whitespace\n");
    }
0  {
      yylval.iValue = 0;
      printf("lex read 0\n");
      return INTEGER_LITERAL;
    }
0(b|B){binarydigit}*  {
      yylval.iValue = strtol(yytext+2,&endptr,2);
      printf("lex read binary integer: %s -> %Ld (%s)\n",yytext,yylval.iValue,endptr);
      return INTEGER_LITERAL;
    }
0{octaldigit}*  {
      yylval.iValue = strtol(yytext+1,&endptr,8);
      printf("lex read octal integer: %s -> %Ld (%s)\n",yytext,yylval.iValue,endptr);
      return INTEGER_LITERAL;
    }
{nonzerodigit}{digit}*  {
      yylval.iValue = strtol(yytext,&endptr,10);
      printf("lex read decimal integer: %s -> %Ld (%s)\n",yytext,yylval.iValue,endptr);
      return INTEGER_LITERAL;
    }
0(x|X){hexidecimaldigit}*  {
      yylval.iValue = strtol(yytext+2,&endptr,16);
      printf("lex read hexidecimal integer: %s -> %Ld (%s)\n",yytext,yylval.iValue,endptr);
      return INTEGER_LITERAL;
    }
"."{digit}+  {
      yylval.fValue = strtod(yytext,&endptr);
      printf("lex read fraction: %s -> %Lf (%s)\n",yytext,yylval.fValue,endptr);
      return FLOAT_LITERAL;
    }
{digit}+"."{digit}*  {
      yylval.fValue = strtod(yytext,&endptr);
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

int yywrap(void) {
  return 1;
}
