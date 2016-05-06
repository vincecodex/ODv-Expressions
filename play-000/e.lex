%{
  #include <stdlib.h>
  #include <stdio.h>
  #include <math.h>
  #include <string.h>
  #include "play.e.h"
  #include "y.tab.h"
  void yyerror(char *);
  char *endptr;
  struct expression *iliteral(long long i);
  struct expression *fliteral(long double f);
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

struct expression *iliteral(long long i) {
  struct expression *literal;
  long long *l;
  literal = malloc(sizeof(struct expression));
  literal->type = EXPRESSION_TYPE_LITERAL_LONG_INTEGER;
  l = malloc(sizeof(long long));
  literal->data = (char *) l;
  *l = i;
  return literal;
}

struct expression *fliteral(long double f) {
  struct expression *literal;
  long double *l;
  literal = malloc(sizeof(struct expression));
  literal->type = EXPRESSION_TYPE_LITERAL_LONG_DOUBLE;
  l = malloc(sizeof(long double));
  literal->data = (char *) l;
  *l = f;
  return literal;
}

int yywrap(void) {
  return 1;
}
