//
//  WebViewTestAppDelegate.m
//  WebViewTest
//
//  Created by sonson on 09/11/24.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "WebViewTestAppDelegate.h"
#import "WebViewTestViewController.h"

@implementation WebViewTestAppDelegate

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
