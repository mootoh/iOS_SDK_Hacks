//
//  EmbededFontAppDelegate.m
//  EmbededFont
//
//  Created by sonson on 09/09/02.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "EmbededFontAppDelegate.h"
#import "EmbededFontViewController.h"

@implementation EmbededFontAppDelegate

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
