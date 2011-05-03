/*
 *  dotproduct.c
 *  AccelerateTest
 *
 *  Created by sonson on 10/08/15.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "vdsp_dotproduct.h"

#include "tool.h"

double test_dotproduct_on_accelerate(int vectorsize, int testCount) {
	float *inputOne, *inputTwo, *result, dotProduct;
	int32_t strideOne=1, strideTwo=1;
	uint32_t size = vectorsize;
	
	int test_count = testCount;
	
	// alloc memory
	inputOne = (float*)malloc(size * sizeof(float));
	inputTwo = (float*)malloc(size * sizeof(float));
	result = (float*)malloc(size * sizeof(float));
	
	// initialize two vectors
	for (int i = 0; i < size; i++) {
		inputOne[i] = 1;
		inputTwo[i] = 0.5;
	}
	
	_tic();
	// dot product by Accelerate.framework
	for (int j = 0; j < test_count; j++) {
		vDSP_dotpr(inputOne, strideOne, inputTwo, strideTwo, &dotProduct, size);
	}
	double t = _toc();
	
	// release objects
	free(inputOne);
	free(inputTwo);
	free(result);
	
	return t / (double)test_count;
}

double test_dotproduct_on_cpu(int vectorsize, int testCount) {
	float *inputOne, *inputTwo, *result;
	volatile float dotProduct;
	uint32_t size = vectorsize;
	
	int test_count = testCount;
	
	// alloc memory
	inputOne = (float*)malloc(size * sizeof(float));
	inputTwo = (float*)malloc(size * sizeof(float));
	result = (float*)malloc(size * sizeof(float));
	
	// initialize two vectors
	for (int i = 0; i < size; i++) {
		inputOne[i] = 1;
		inputTwo[i] = 0.5;
	}
	
	_tic();
	// dot product
	for (int j = 0; j < test_count; j++) {
		dotProduct = 0;
		for (int i = 0; i < size; i++) {
			dotProduct += inputOne[j] * inputTwo[j];
		}
	}
	double t = _toc();
	
	// release objects
	free(inputOne);
	free(inputTwo);
	free(result);
	
	return t / (double)test_count;
}