//
//  MonochromeSIMDAppDelegate.m
//  MonochromeSIMD
//
//  Created by Motohiro Takayama on 8/9/10.
//  Copyright deadbeaf.org 2010. All rights reserved.
//

#import "MonochromeSIMDAppDelegate.h"
#import "MonochromeSIMDViewController.h"

@implementation MonochromeSIMDAppDelegate

@synthesize window;
@synthesize viewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   [window addSubview:viewController.view];
   [window makeKeyAndVisible];
   
   return YES;
}

- (void)dealloc
{
   [viewController release];
   [window release];
   [super dealloc];
}


@end