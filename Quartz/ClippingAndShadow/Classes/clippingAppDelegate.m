//
//  clippingAppDelegate.m
//  clipping
//
//  Created by sonson on 09/05/06.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "clippingAppDelegate.h"
#import "clippingViewController.h"

@implementation clippingAppDelegate

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
