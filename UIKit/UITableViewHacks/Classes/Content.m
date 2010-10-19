//
//  Content.m
//  UITableViewHacks
//
//  Created by sonson on 10/03/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Content.h"

@implementation Content

@synthesize icon, title;

- (id) initWithNumber:(int)num {
	self = [super init];
	if (self != nil) {
		title = [[NSString stringWithFormat:@"%040d", num] retain];
		icon = [[UIImage imageNamed:@"2tchSmall.png"] retain];
	}
	return self;
}

- (void) dealloc {
	[icon release];
	[title release];
	[super dealloc];
}


@end
