//
//  TaskViewController.m
//  NSOperationTest
//
//  Created by sonson on 10/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TaskViewController.h"
#import "MyOperation.h"

@implementation TaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	MyOperation *op = [[[MyOperation alloc] initWithDelegate:self] autorelease];
	[queue addOperation:op];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

#define _CANCEL
//#define _WAIT
	
#ifdef _CANCEL
	NSArray *ops = [queue operations];
	for (NSOperation *op in ops) {
		[op cancel];
	}
#endif
	
#ifdef _WAIT
	[queue waitUntilAllOperationsAreFinished];
#endif
}

- (void)dealloc {
	[queue release];
    [super dealloc];
}

@end
