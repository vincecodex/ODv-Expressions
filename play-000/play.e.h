#ifndef PLAY_E_H
#define PLAY_E_H

#include <math.h>

struct uval {
  char *nom;
  long double (*ptr)(long double);
};

struct bval {
  char *nom;
  long double (*ptr)(long double, long double);
};

long double lg(long double);

struct system {
  struct equation **system;
};

struct equation {
  struct expression *left, *right;
};

struct algorithm {
  struct assignment **system;
};

struct assignment {
  int varcode;
  char *var;
  struct expression *exp;
};

struct expression {
  int type;
  char *data;
};

struct binary_operator_type {
  char *name;
  char *symbol;
  long double (*operate_ldb)(long double,long double);
};

struct unary_operator_type {
  char *name;
  char *symbol;
  long double (*operate_ldb)(long double);
};

struct binary_operator {
  struct binary_operator_type *type;
  struct expression *left, *right;
};

struct unary_operator {
  struct unary_operator_type *type;
  struct expression *child;
};

struct node_stack {
  struct expression *node;
  int state;
  struct node_stack *next;
};

#define EXPRESSION_TYPE_LITERAL_INTEGER 0

#define EXPRESSION_TYPE_LITERAL_LONG_INTEGER 1

#define EXPRESSION_TYPE_LITERAL_FLOAT 2

#define EXPRESSION_TYPE_LITERAL_DOUBLE 3

#define EXPRESSION_TYPE_LITERAL_LONG_DOUBLE 4

#define EXPRESSION_TYPE_VARIABLE 5

#define EXPRESSION_TYPE_UNARY_OPERATOR 6

#define EXPRESSION_TYPE_BINARY_OPERATOR 7

extern struct binary_operator_type BIN_OP_ADDITION;

extern struct binary_operator_type BIN_OP_SUBTRACTION;

extern struct binary_operator_type BIN_OP_MULTIPLICATION;

extern struct binary_operator_type BIN_OP_DIVISION;

extern struct binary_operator_type BIN_OP_EXPONENTIATION;

extern struct unary_operator_type UN_OP_NEGATION;

extern struct unary_operator_type UN_OP_ABSOLUTE;

extern struct unary_operator_type UN_OP_CEILING;

extern struct unary_operator_type UN_OP_FLOOR;

void print_tree(struct expression *);

#endif
