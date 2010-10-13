/*
 *  vdsp_int2float.c
 *  AccelerateTest
 *
 *  Created by sonson on 10/08/15.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "vdsp_int2float.h"

double test_cpu_convert_int2float_size(int size, int test_count) {
	CFAbsoluteTime startTime;
	
	float *destination = NULL;
	unsigned char *source = NULL;
	
	// alloc objects
	destination = (float*)malloc(size * sizeof(float));
	source = (unsigned char*)malloc(size * sizeof(unsigned char));
	
	// initialize two vectors
	for (int i = 0; i < size; i++) {
		*(destination + i) = 0;
		*(source + i) = i%256;
	}
	
	// use CPU
	startTime = CFAbsoluteTimeGetCurrent();
	for (int c = 0; c < test_count; c++) {
		for (int i = 0; i < size; i++) {
			*(destination + i) = *(source + i);
		}
	}
	double t = ((CFAbsoluteTimeGetCurrent() - startTime)*1000.0f);
	
	// release objects
	free(source);
	free(destination);
	
	return t;
}

double test_vDSP_convert_int2float_size(int size, int test_count) {
	CFAbsoluteTime startTime;
	
	float *destination = NULL;
	unsigned char *source = NULL;

	// alloc objects
	destination = (float*)malloc(size * sizeof(float));
	source = (unsigned char*)malloc(size * sizeof(unsigned char));
	
	// initialize two vectors
	for (int i = 0; i < size; i++) {
		*(destination + i) = 0;
		*(source + i) = i%256;
	}

	// use vDSP
	startTime = CFAbsoluteTimeGetCurrent();
	for (int c = 0; c < test_count; c++) {
		vDSP_vfltu8(source, 1, destination, 1, size);
	}
	double t = ((CFAbsoluteTimeGetCurrent() - startTime)*1000.0f);
	
	// release objects
	free(source);
	free(destination);
	
	return t;
}

void test_convert_int2float() {
	printf("--------------------------------------------------------------------------------\n");
	printf("test_convert_int2float\n");
	printf("--------------------------------------------------------------------------------\n");
	
	for (int size = 2; size <= 8192; size *=16 ) {
		int test_count = 100;
		
		printf("----------------------------------------\n");
		printf("Condition\n");
		printf(" %d-dim vec\n", size);
		printf(" test, %d times\n", test_count);
		
		CFAbsoluteTime t1 = test_vDSP_convert_int2float_size(size, test_count);
		CFAbsoluteTime t2 = test_cpu_convert_int2float_size(size, test_count);
		
		printf("----------------------------------------\n");
		printf("Result\n");
		printf("Accelerate.framework\n");
		printf(" %f msec\n", t1);
		printf("Normal\n");
		printf(" %f msec\n", t2);
	}
	printf("\n");
}