/*
 *  lapack_linearEquation.h
 *  AccelerateTest
 *
 *  Created by sonson on 10/08/15.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#import <CoreFoundation/CoreFoundation.h>
#import <Accelerate/Accelerate.h>

#ifdef __cplusplus
extern "C" {
#endif
	double test_linearEquation_on_acclerate(int size, int test_count);	
	double test_linearEquation_on_cpu(int size, int test_count);
#ifdef __cplusplus
}
#endif
