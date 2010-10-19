//
//  dumpSubviewViewController.m
//  dumpSubview
//
//  Created by sonson on 09/04/02.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "dumpSubviewViewController.h"

#if TARGET_IPHONE_SIMULATOR
	#import <objc/objc-runtime.h>
#else
	#import <objc/runtime.h>
#endif

void dumpSubview( UIView* view ) {
    NSLog( @"%s", class_getName([view class]) );
    for( UIView *subview in [view subviews] ) {
        dumpSubview( subview );
    }
}

@implementation dumpSubviewViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	UIWebView* bar = [[UIWebView alloc] initWithFrame:CGRectZero];
	dumpSubview(bar);
	[bar release];
}

- (void)dealloc {
    [super dealloc];
}

@end
