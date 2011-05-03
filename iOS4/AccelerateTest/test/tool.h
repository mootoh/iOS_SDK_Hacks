/*
 *  tool.h
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
	void _tic();
	double _toc();
	double _tocp();
#ifdef __cplusplus
}
#endif
