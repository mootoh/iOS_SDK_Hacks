//
//  dumpSubviewAppDelegate.m
//  dumpSubview
//
//  Created by sonson on 09/04/02.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "dumpSubviewAppDelegate.h"
#import "dumpSubviewViewController.h"

@implementation dumpSubviewAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
