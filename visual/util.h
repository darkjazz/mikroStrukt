/*
 *  fxutil.h
 *  Fx
 *
 *  Created by alo on 20/01/2009.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#include "stdlib.h"
#include "math.h"

void initrand();
float map(float, float, float);
float unmap(float, float, float);
int randint(int, int);
float randf();
float randfloat(float, float);
int xmod(int, int);
int wrapi(int, int, int);
float wrapf(float, float, float);
float xmodf(float, float);
float clipf(float, float, float);