/*
 *  blas_matrix_mult_vec.c
 *  AccelerateTest
 *
 *  Created by sonson on 10/08/15.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "blas_matrix_mult_vec.h"

static void disp_matrix(float *matrix, int row_size, int column_size) {
	for (int i = 0; i < row_size; i++) {
		for (int j = 0; j < column_size; j++) {
			printf("%f ", matrix[i+row_size*j]);
		}
		printf("\n");
	}
}

static void disp_vec(float *vec, int size) {
	for (int i = 0; i < size; i++) {
		printf("%f\n", vec[i]);
	}
}

static void initialize_matrix(float *matrix, int row_size, int column_size) {
	for (int i = 0; i < row_size; i++) {
		for (int j = 0; j < column_size; j++) {
			matrix[i+row_size*j] = i;
		}
	}
}

static void set_vec(float *vec, float value, int size) {
	for (int i = 0; i < size; i++) {
		vec[i] = value;
	}
}

static void test_with_accelerate(int row_size, int column_size, int test_count) {
	CFAbsoluteTime startTime = 0;
	float *vec = (float*)malloc(sizeof(float) * row_size);
	float *matrix = (float*)malloc(sizeof(float) * row_size * column_size);
	float *r_vec = (float*)malloc(sizeof(float) * row_size);
	
	CFAbsoluteTime accum = 0;
	
	for (int c = 0; c < test_count; c++) {
		
		// データ初期化
		initialize_matrix(matrix, row_size, column_size);
		set_vec(vec, 1, column_size);
		set_vec(r_vec, 0, column_size);
		
		
		startTime = CFAbsoluteTimeGetCurrent();
		cblas_sgemv(CblasColMajor, CblasNoTrans, row_size, column_size, 1, matrix, row_size, vec, 1, 1, r_vec, 1);
		accum += (CFAbsoluteTimeGetCurrent() - startTime);
	}
	
	printf(" %f msec\n", accum * 1000.0f );
	
	free(r_vec);
	free(vec);
	free(matrix);	
}

static void test_with_cpu(int row_size, int column_size, int test_count) {
	CFAbsoluteTime startTime = 0;
	float *vec = (float*)malloc(sizeof(float) * row_size);
	float *matrix = (float*)malloc(sizeof(float) * row_size * column_size);
	float *r_vec = (float*)malloc(sizeof(float) * row_size);
	
	CFAbsoluteTime accum = 0;
	
	for (int c = 0; c < test_count; c++) {
		
		// データ初期化
		initialize_matrix(matrix, row_size, column_size);
		set_vec(vec, 1, column_size);
		set_vec(r_vec, 0, column_size);
		
		
		startTime = CFAbsoluteTimeGetCurrent();
		for (int i = 0; i < row_size; i++) {
			float k = 0;
			for (int j = 0; j < column_size; j++) {
				k +=  matrix[i*column_size+j] * vec[j];
			}
			r_vec[i] = k;
		}
		accum += (CFAbsoluteTimeGetCurrent() - startTime);
	}
	
	printf(" %f msec\n", accum * 1000.0f );
	
	free(r_vec);
	free(vec);
	free(matrix);	
}

void test_matrix_mult_vec() {
	int row_size = 2048;
	int column_size = 2048;
	int test_count = 10;
	
	printf("--------------------------------------------------------------------------------\n");
	printf("multiply matrix and vector, BLAS\n");
	printf("--------------------------------------------------------------------------------\n");
	
	printf("----------------------------------------\n");
	printf("Condition\n");
	// display condition
	printf(" %dx%d matrix size\n", row_size, column_size);
	printf(" test, %d times\n", test_count);
	
	printf("----------------------------------------\n");
	printf("Result\n");
	
	printf("Accelerate.framework\n");
	test_with_accelerate(row_size, column_size, test_count);
	
	printf("Normal\n");
	test_with_cpu(row_size, column_size, test_count);
	printf("\n");
}