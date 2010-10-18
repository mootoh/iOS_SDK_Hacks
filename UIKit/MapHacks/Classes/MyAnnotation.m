//
//  MyAnnotation.m
//  MapHacks
//
//  Created by sonson on 09/08/31.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize coordinate, title, subtitle;

- (void)dealloc {
	[title release];
	[subtitle release];
	[super dealloc];
}

@end
