#include "play.e.h"

#include <stdlib.h>
#include <stdio.h>

long double lg(long double num) {
  return logl( num ) / logl( 2 );
}

long double sum_ldb(long double a, long double b) {
  return a + b;
}

long double difference_ldb(long double a, long double b) {
  return a - b;
}

long double product_ldb(long double a, long double b) {
  return a * b;
}

long double quotient_ldb(long double a, long double b) {
  return a / b;
}

long double power_ldb(long double a, long double b) {
  return powl(a,b);
}

long double negative_ldb(long double n) {
  return -n;
}

long double abs_ldb(long double n) {
  return fabsl(n);
}

long double ceil_ldb(long double n) {
  return ceill(n);
}

long double floor_ldb(long double n) {
  return floorl(n);
}

struct binary_operator_type BIN_OP_ADDITION = { "addition", "+", sum_ldb };

struct binary_operator_type BIN_OP_SUBTRACTION = { "subtraction", "-", difference_ldb };

struct binary_operator_type BIN_OP_MULTIPLICATION = { "multiplication", "*", product_ldb };

struct binary_operator_type BIN_OP_DIVISION = { "division", "/", quotient_ldb };

struct binary_operator_type BIN_OP_EXPONENTIATION = { "exponentiation", "^", power_ldb };

struct unary_operator_type UN_OP_NEGATION = { "negation", "(-)", negative_ldb };

struct unary_operator_type UN_OP_ABSOLUTE = { "absolute value", "|", abs_ldb };

struct unary_operator_type UN_OP_CEILING = { "ceil", "|^", ceil_ldb };

struct unary_operator_type UN_OP_FLOOR = { "floor", "|_", floor_ldb };

long long getLD(struct expression *e) {
  long long *p;
  p = (long long *) e->data;
  return *p;
}

long double getLF(struct expression *e) {
  long double *p;
  p = (long double *) e->data;
  return *p;
}

void print_tree_internal(struct expression *e,char *t,int l) {
  struct binary_operator *b;
  struct unary_operator *u;
  char *n;
  n = malloc(l+2);
  sprintf(n,"\t%s",t);
  if( e == 0 ) {
    printf("%sNULL\n",t);
    return;
  }
  switch(e->type) {
    case EXPRESSION_TYPE_LITERAL_LONG_INTEGER:
      printf("%s%Ld\n",t,getLD(e));
      break;
    case EXPRESSION_TYPE_LITERAL_LONG_DOUBLE:
      printf("%s%Lf\n",t,getLF(e));
      break;
    case EXPRESSION_TYPE_BINARY_OPERATOR:
      b = (struct binary_operator *) e->data;
      print_tree_internal(b->left,n,l+1);
      printf("%s%s:\n",t,b->type->name);
      print_tree_internal(b->right,n,l+1);
      break;
    case EXPRESSION_TYPE_UNARY_OPERATOR:
      u = (struct unary_operator *) e->data;
      printf("%s%s:\n",t,u->type->name);
      print_tree_internal(u->child,n,l+1);
      break;
  }
  //free(n);
}

void print_tree(struct expression *e) {
  char *t;
  t = malloc(1);
  t[0] = 0;
  print_tree_internal(e,t,0);
}
