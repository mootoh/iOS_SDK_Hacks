/*
 *  vdsp_abs.c
 *  AccelerateTest
 *
 *  Created by sonson on 10/08/15.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "vdsp_abs.h"

static void check_absolute_value(float *a, float *b, int size) {
	for (int i = 0; i < size; i++) {
		if (*(b + i) != fabsf(*(a + i))) {
			printf("check_absolute_value->error\n");
			return;
		}
	}
	printf("check_absolute_value->OK\n");
}

static double test_cpu_abs(int size, int test_count) {
	srandom(time(NULL));
	CFAbsoluteTime startTime;
	
	float *destination = NULL;
	float *source = NULL;
	
	// alloc objects
	destination = (float*)malloc(size * sizeof(float));
	source = (float*)malloc(size * sizeof(float));
	
	// initialize two vectors
	for (int i = 0; i < size; i++) {
		*(destination + i) = 0;
		*(source + i) = 10 - rand()%10;
	}
	
	// use CPU
	startTime = CFAbsoluteTimeGetCurrent();
	for (int c = 0; c < test_count; c++) {
		for (int i = 0; i < size; i++) {
			*(destination + i) = fabsf(*(source + i));
		}
	}
	double t = ((CFAbsoluteTimeGetCurrent() - startTime)*1000.0f);
	
	check_absolute_value(source, destination, size);
	
	// release objects
	free(source);
	free(destination);
	
	return t;
}

static double test_vDSP_abs(int size, int test_count) {
	srandom(time(NULL));
	CFAbsoluteTime startTime;
	
	float *destination = NULL;
	float *source = NULL;

	// alloc objects
	destination = (float*)malloc(size * sizeof(float));
	source = (float*)malloc(size * sizeof(float));
	
	// initialize two vectors
	for (int i = 0; i < size; i++) {
		*(destination + i) = 0;
		*(source + i) = 10 - rand()%10;
	}

	// use vDSP
	startTime = CFAbsoluteTimeGetCurrent();
	for (int c = 0; c < test_count; c++) {
		vDSP_vabs(source, 1, destination, 1, size);
	}
	double t = ((CFAbsoluteTimeGetCurrent() - startTime)*1000.0f);
	
	// check
	check_absolute_value(source, destination, size);
	
	// release objects
	free(source);
	free(destination);
	
	return t;
}

void test_abs() {
	printf("--------------------------------------------------------------------------------\n");
	printf("test_abs\n");
	printf("--------------------------------------------------------------------------------\n");
	
	for (int size = 2; size <= 8192; size *=16 ) {
		int test_count = 100;
		
		printf("----------------------------------------\n");
		printf("Condition\n");
		printf(" %d-dim vec\n", size);
		printf(" test, %d times\n", test_count);
		
		CFAbsoluteTime t1 = test_vDSP_abs(size, test_count);
		CFAbsoluteTime t2 = test_cpu_abs(size, test_count);
		
		printf("----------------------------------------\n");
		printf("Result\n");
		printf("Accelerate.framework\n");
		printf(" %f msec\n", t1);
		printf("Normal\n");
		printf(" %f msec\n", t2);
	}
	printf("\n");
}