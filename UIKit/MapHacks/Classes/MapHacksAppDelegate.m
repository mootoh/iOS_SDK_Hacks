//
//  MapHacksAppDelegate.m
//  MapHacks
//
//  Created by sonson on 09/08/30.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MapHacksAppDelegate.h"
#import "MapHacksViewController.h"

@implementation MapHacksAppDelegate

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
