//
//  TestController.m
//  AccelerateTest
//
//  Created by sonson on 11/05/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestController.h"

#import "vdsp_dotproduct.h"

@implementation TestController

- (NSString*)testDotProduct {
	NSMutableString *string = [NSMutableString string];
	
	[string appendString:@"\n"];
	
	int testCount = 100;
	
	for (int i = 0; i < 10; i++) {
		int vectorSize = (int)powl(2, i+1);
		
		double t_cpu = test_dotproduct_on_cpu(vectorSize, testCount);
		double t_accelerate = test_dotproduct_on_accelerate(vectorSize, testCount);
		
		[string appendFormat:@"Test vector size\n%d\n", vectorSize];
		[string appendFormat:@"CPU\n%f msec\n", t_cpu];
		[string appendFormat:@"Accelerate.framework\n%f msec\n\n", t_accelerate];
		
	}
	
	NSLog(@"%@", string);
	
	return [NSString stringWithString:string];
}

@end
