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

#endif
