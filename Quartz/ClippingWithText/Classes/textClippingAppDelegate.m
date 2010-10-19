//
//  textClippingAppDelegate.m
//  textClipping
//
//  Created by sonson on 09/05/06.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "textClippingAppDelegate.h"
#import "textClippingViewController.h"

@implementation textClippingAppDelegate

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
