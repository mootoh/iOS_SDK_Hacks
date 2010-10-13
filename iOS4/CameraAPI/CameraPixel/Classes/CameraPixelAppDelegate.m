//
//  CameraPixelAppDelegate.m
//  CameraPixel
//
//  Created by sonson on 10/06/26.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "CameraPixelAppDelegate.h"
#import "RootViewController.h"

@implementation CameraPixelAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	rootController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootController];
	[window addSubview:nav.view];
	[window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end
