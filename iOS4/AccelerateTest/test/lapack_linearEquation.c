/*
 *  vdsp_int2float.c
 *  AccelerateTest
 *
 *  Created by sonson on 10/08/15.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "lapack_linearEquation.h"

// make matrix and vector

void matrixfill_random(float *matrix, int row_size, int column_size) {
	srandom(time(NULL));
	for (int i = 0; i < row_size; i++) {
		for (int j = 0; j < column_size; j++) {
			matrix[ j + column_size * i] = rand()%10;
		}
	}
}

void vectorfill_random(float *vector, int row_size) {
	srandom(time(NULL));
	for (int i = 0; i < row_size; i++) {
		vector[i] = rand()%10;
	}
}

// calculate with gauss elimination

double gauss (float *matrix, float *vec, float *vec_x, int size) {
	int i,j,k,c;
	
	float **array = (float**)malloc(sizeof(float*) * size);
	
	for (int i = 0; i < size; i++) {
		*(array+i) = (float*)malloc(sizeof(float) * (size + 1));
	}
	
	float dum,pivot,aik,akj,max;
	
	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++) {
			array[j][i] = matrix[ j + size * i];
		}
	}
	
	for (int i = 0; i < size; i++) {
		array[i][size] = vec[i];
	}
	
	CFAbsoluteTime startTime;
	startTime = CFAbsoluteTimeGetCurrent();
	
	/* check :pivot */
	for(k=0;k<size;k++){
		max=0;
		c=k;
		for(j=k;j<size;j++){
			if(fabs(array[j][k])>max){
				max=fabs(array[j][k]);
				c=j;
			}
		}
		if(max==0){
			printf("no-solution\n");
			exit(1);
		}
		for(j=0;j<=size;j++){
			dum=array[k][j];
			array[k][j]=array[c][j];
			array[c][j]=dum;
		}
		/* gauss  */
		pivot=array[k][k];
		if(pivot==0){
			printf("no-solution\n");
			exit(1);
		}
		
		for(j=k;j<=size;j++){
			array[k][j]/=pivot;
		}
		for(i=k+1;i<size;i++){
			aik=array[i][k];
			for(j=k;j<=size;j++){
				array[i][j]-=array[k][j]*aik;
			}
		}
	}
	for(k=size-2;k>=0;k--){
		for(j=size-1;j>k;j--){
			akj=array[k][j];
			array[k][size]-=akj*array[j][size];
			array[k][j]-=akj*array[j][j];
		}
	}
	
	CFAbsoluteTime interval = (CFAbsoluteTimeGetCurrent() - startTime)*1000.0f;
	
	for (int i = 0; i < size; i++) {
		vec_x[i] = array[i][size];
	}
	
	for (int i = 0; i < size; i++) {
		free(*(array+i));
	}
	
	free(array);
	
	return interval;
}

double lapack(float *matrix, float *vec, int size) {
	
	__CLPK_integer n = size;
	__CLPK_integer nrhs = 1;
	__CLPK_integer ldb = size;
	__CLPK_integer info = 0;
	__CLPK_integer *ipiv;
	ipiv = (__CLPK_integer*)malloc(sizeof(__CLPK_integer) * size);
	
	CFAbsoluteTime startTime;
	startTime = CFAbsoluteTimeGetCurrent();
	sgesv_(&n, &nrhs, matrix, &ldb, ipiv, vec, &ldb, &info);
	
	CFAbsoluteTime interval = (CFAbsoluteTimeGetCurrent() - startTime)*1000.0f;
	
	free(ipiv);
	
	return interval;
}

void test_linearEquation() {
	printf("--------------------------------------------------------------------------------\n");
	printf("linear equation\n");
	printf("--------------------------------------------------------------------------------\n");
	
	for (int size = 2; size < 256; size *= 2) {
		float *matrix;
		float *vec_b;
		float *vec_x;
		float *vec;
		
		int test_count = 10;
		
		// alloc memory
		matrix = (float*)malloc(sizeof(float) * size * size);
		vec_b = (float*)malloc(sizeof(float) * size);
		vec_x = (float*)malloc(sizeof(float) * size);
		vec = (float*)malloc(sizeof(float) * size);
		
		CFTimeInterval gaussTime = 0;
		CFTimeInterval accTime = 0;
		
		for (int c = 0; c < test_count; c++) {
			// make matrix and vector
			matrixfill_random(matrix, size, size);
			vectorfill_random(vec_b, size);
			
			gaussTime += gauss(matrix, vec_b, vec_x, size);
			accTime += lapack(matrix, vec_b, size);
			
//			printf("----------------------------------------\n");
//			float distance = 0;
//			printf("Result confirmation\n");
//			vDSP_vsub(vec_b, 1, vec_x, 1, vec, 1, size);
//			vDSP_svesq(vec, 1, &distance, size);
//			printf(" difference between two methods => %f\n", distance);
		}
		
		printf("----------------------------------------\n");
		printf("Condition\n");
		printf(" %dx%d matrix\n", size, size);
		printf(" %d sampling\n", test_count);
		
		printf("----------------------------------------\n");
		printf("Result\n");
		printf("Accelerate.framework\n");
		printf(" %f msec\n", accTime/test_count);
		printf("Normal\n");
		printf(" %f msec\n", gaussTime/test_count);
		printf("\n");
		
		// release memory
		free(vec);
		free(matrix);
		free(vec_b);
		free(vec_x);
	}
}