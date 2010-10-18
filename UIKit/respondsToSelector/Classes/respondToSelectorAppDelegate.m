//
//  respondToSelectorAppDelegate.m
//  respondToSelector
//
//  Created by sonson on 09/04/08.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "respondToSelectorAppDelegate.h"
#import "respondToSelectorViewController.h"

@implementation respondToSelectorAppDelegate

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
