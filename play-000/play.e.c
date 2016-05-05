#include "play.e.h"

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

struct binary_operator_type BIN_OP_ADDITION = { "addition", "+", sum_ldb };

struct binary_operator_type BIN_OP_SUBTRACTION = { "subtraction", "-", difference_ldb };

struct binary_operator_type BIN_OP_MULTIPLICATION = { "multiplication", "*", product_ldb };

struct binary_operator_type BIN_OP_DIVISION = { "division", "/", quotient_ldb };

struct binary_operator_type BIN_OP_EXPONENTIATION = { "exponentiation", "^", power_ldb };

struct unary_operator_type UN_OP_NEGATION = { "negation", "(-)", negative_ldb };

struct unary_operator_type UN_OP_SQUARE = { "square", "^2", square_ldb };

struct unary_operator_type UN_OP_SQUARE_ROOT = { "square root", "(sqrt)", root_ldb };
