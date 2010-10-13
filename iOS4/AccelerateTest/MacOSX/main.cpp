#include <iostream>

#import "vdsp_dotproduct.h"
#import "blas_matrix_mult_vec.h"
#import "vdsp_int2float.h"
#import "lapack_linearEquation.h"
#import "vdsp_abs.h"

int main (int argc, char * const argv[]) {
    
	// test code
	printf("press any key to start...\n");
	getchar();
	
	// dot product
	test_dotproduct();
	
	// matrix
	test_matrix_mult_vec();
	
	// copy values to vector
	test_convert_int2float();
	
	// linear equation
	test_linearEquation();
	
	// absolute values
	test_abs();
	
    return 0;
}
