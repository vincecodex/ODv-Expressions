/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IDENTIFIER = 258,
    INTEGER_LITERAL = 259,
    FLOAT_LITERAL = 260,
    OP_PL = 261,
    OP_MI = 262,
    OP_MU = 263,
    OP_DI = 264,
    OP_EX = 265,
    BR_OP = 266,
    BR_CP = 267,
    BR_AB = 268,
    BR_OC = 269,
    BR_CC = 270,
    BR_OF = 271,
    BR_CF = 272,
    SP_CM = 273,
    NEW_LINES = 274,
    UNARY_FUNCTION = 275,
    BINARY_FUNCTION = 276
  };
#endif
/* Tokens.  */
#define IDENTIFIER 258
#define INTEGER_LITERAL 259
#define FLOAT_LITERAL 260
#define OP_PL 261
#define OP_MI 262
#define OP_MU 263
#define OP_DI 264
#define OP_EX 265
#define BR_OP 266
#define BR_CP 267
#define BR_AB 268
#define BR_OC 269
#define BR_CC 270
#define BR_OF 271
#define BR_CF 272
#define SP_CM 273
#define NEW_LINES 274
#define UNARY_FUNCTION 275
#define BINARY_FUNCTION 276

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 13 "e.y" /* yacc.c:1909  */

  long long iValue;
  long double fValue;
  char *sValue;
  struct uval uValue;
  struct bval bValue;

#line 104 "y.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
