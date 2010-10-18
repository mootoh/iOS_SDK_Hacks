//
//  UITableViewHacksAppDelegate.m
//  UITableViewHacks
//
//  Created by sonson on 10/03/11.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "UITableViewHacksAppDelegate.h"
#import "RootViewController.h"


@implementation UITableViewHacksAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch
	RootViewController *root = [[RootViewController alloc] initWithStyle:UITableViewStylePlain];
	navigationController = [[UINavigationController alloc] initWithRootViewController:root];
	
	[root release];
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

