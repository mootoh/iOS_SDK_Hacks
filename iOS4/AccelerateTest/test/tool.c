/*
 *  tool.c
 *  AccelerateTest
 *
 *  Created by sonson on 10/08/15.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

static struct timeval _start, _end;

void _tic() {
	gettimeofday(&_start, NULL);
}

double _toc() {
	gettimeofday(&_end, NULL);
	long int e_sec = _end.tv_sec * 1000000 + _end.tv_usec;
	long int s_sec = _start.tv_sec * 1000000 + _start.tv_usec;
	return (double)((e_sec - s_sec) / 1000.0);
}

double _tocp() {
	gettimeofday(&_end, NULL);
	long int e_sec = _end.tv_sec * 1000000 + _end.tv_usec;
	long int s_sec = _start.tv_sec * 1000000 + _start.tv_usec;
	double t = (double)((e_sec - s_sec) / 1000.0);
	printf("%6.3f\n", t);
	return t;
}