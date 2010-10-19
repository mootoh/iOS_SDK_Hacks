//
//  MyOperation.m
//  NSOperationTest
//
//  Created by sonson on 10/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyOperation.h"


@implementation MyOperation

- (id)initWithDelegate:(id)aDelegate {	
	self = [super init];
	if (self != nil) {
		delegate = aDelegate;
	}
	return self;
}

- (void)main {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	for (int i = 0; i < 10; i++) {
		NSLog(@"%d sec", i);
		[NSThread sleepForTimeInterval:1];
		if ([self isCancelled]) {
			NSLog(@"Cancelled");
			break;
		}
	}
	
	[pool release];
}

@end
