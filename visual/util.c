/*
 *  fxutil.c
 *  Fx
 *
 *  Created by alo on 20/01/2009.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "util.h"

void initrand() 
{ 
    srand((unsigned)(time(0))); 
} 

float map(float val, float lo, float hi)
{
	return val * (hi - lo) + lo;
}

float unmap(float val, float lo, float hi)
{
	return ((val - lo) / (hi - lo));
}

int randint(int min, int max) 
{ 
    if (min>max) 
    { 
        return max+(int)((min-max+1)*rand()/(RAND_MAX+1.0)); 
    } 
    else 
    { 
        return min+(int)((max-min+1)*rand()/(RAND_MAX+1.0)); 
    } 
}

float randf() 
{ 
	float val;
	val = rand()/((float)(RAND_MAX)+1);
    return val; 
} 

float randfloat(float min, float max) 
{ 
    if (min>max) 
    { 
        return randf()*(min-max)+max;     
    } 
    else 
    { 
        return randf()*(max-min)+min; 
    }     
} 

int xmod(int a, int n) {
	return a - (n * floor(a / (double)n));
}

int wrapi(int val, int lo, int hi) {
	int rtn;
	rtn = xmod((val - lo), (hi - lo + 1)) + lo;
	return rtn;
}

float wrapf(float val, float lo, float hi)
{
	return xmodf(val - lo, hi - lo) + lo;
}

float xmodf(float value, float hi)
{
	return value - hi*floor(value/hi);
}

int max(int a, int b)
{
	if (a > b)
		return a;
	else
		return b;
}

float clipf(float val, float min, float max)
{
	if (val < min)
		val = min;
	if (val > max)
		val = max;
	return	val;
}
