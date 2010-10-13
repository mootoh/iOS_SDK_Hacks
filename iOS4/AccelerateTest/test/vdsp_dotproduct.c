/*
 *  dotproduct.c
 *  AccelerateTest
 *
 *  Created by sonson on 10/08/15.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "vdsp_dotproduct.h"

void test_dotproduct() {
	printf("--------------------------------------------------------------------------------\n");
	printf("dot product\n");
	printf("--------------------------------------------------------------------------------\n");
	
	CFAbsoluteTime startTime;
	float *inputOne, *inputTwo, *result, dotProduct;
	int32_t strideOne=1, strideTwo=1;
	uint32_t size = 1024;
	
	int test_count = 100;
	
	// alloc memory
	inputOne = (float*)malloc(size * sizeof(float));
	inputTwo = (float*)malloc(size * sizeof(float));
	result = (float*)malloc(size * sizeof(float));
	
	// initialize two vectors
	for (int i = 0; i < size; i++) {
		inputOne[i] = 1;
		inputTwo[i] = 0.5;
	}
	
	printf("----------------------------------------\n");
	printf("Condition\n");
	// display condition
	printf(" %d-dim vec\n", size);
	printf(" test, %d times\n", test_count);
	
	printf("----------------------------------------\n");
	printf("Result\n");
	// use vDSP
	startTime=CFAbsoluteTimeGetCurrent();
	for (int j = 0; j < test_count; j++) {
		vDSP_dotpr(inputOne, strideOne, inputTwo, strideTwo, &dotProduct, size);
	}
	printf("Accelerate.framework\n");
	printf(" %f msec\n", (CFAbsoluteTimeGetCurrent() - startTime)*1000.0f );
	
	// use CPU
	startTime=CFAbsoluteTimeGetCurrent();
	for (int j = 0; j < test_count; j++) {
		dotProduct = 0;
		for (int i = 0; i < size; i++) {
			dotProduct += inputOne[j] * inputTwo[j];
		}
	}
	printf("Normal\n");
	printf(" %f msec\n", (CFAbsoluteTimeGetCurrent() - startTime)*1000.0f );
	printf("\n");
	
	// release objects
	free(inputOne);
	free(inputTwo);
	free(result);
}