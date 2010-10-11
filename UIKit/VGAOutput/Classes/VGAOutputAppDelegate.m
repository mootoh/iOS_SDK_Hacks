//
//  VGAOutputAppDelegate.m
//  VGAOutput
//
//  Created by sonson on 10/09/14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "VGAOutputAppDelegate.h"
#import "VGAOutputViewController.h"
#import "ExternalViewController.h"

@implementation VGAOutputAppDelegate

@synthesize window, externalWindow;
@synthesize viewController;
@synthesize externalViewController;

- (void)showAlertViewForModeSelect {
	if ([[UIScreen screens] count] > 1) {
		UIScreen *secondScreen = [[UIScreen screens] objectAtIndex:1];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"外部ディスプレイが接続されました．" 
														message:@"外部ディスプレイのサイズ	を選んでください．" 
													   delegate:self 
											  cancelButtonTitle:nil 
											  otherButtonTitles:nil];
		
		for (UIScreenMode *mode in [secondScreen availableModes]) {
			[alert addButtonWithTitle:[NSString stringWithFormat:@"%dx%d", (int)mode.size.width, (int)mode.size.height]];
		}
		[alert addButtonWithTitle:[NSString stringWithFormat:@"Cancel"]];
		[alert show];
		[alert release];
	}
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"%d", buttonIndex);
	if ([[UIScreen screens] count] > 1) {
		UIScreen *secondScreen = [[UIScreen screens] objectAtIndex:1];
		if (buttonIndex < [[secondScreen availableModes] count]) {
			UIScreenMode *selectedScreenMode = [[secondScreen availableModes] objectAtIndex:buttonIndex];
			
			[secondScreen setCurrentMode:selectedScreenMode];
			
			[externalWindow setScreen:secondScreen];
			[externalWindow setFrame:CGRectMake(0, 0, selectedScreenMode.size.width, selectedScreenMode.size.height)];
			[externalViewController.view setFrame:CGRectMake(0, 0, selectedScreenMode.size.width, selectedScreenMode.size.height)];
			[externalWindow addSubview:externalViewController.view];
			[externalWindow makeKeyAndVisible];
		}
	}
}

#pragma mark -
#pragma mark UIScreenNotification

- (void)didUIScreenConnect:(NSNotification*)notification {
	// 外部ディスプレイが接続された
	[self showAlertViewForModeSelect];
}

- (void)didUIScreenDisconnect:(NSNotification*)notification {
	// 外部ディスプレイが切断された
}

- (void)didUIScreenChange:(NSNotification*)notification {
	// 外部ディスプレイの状態が変更した
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUIScreenConnect:) name:UIScreenDidConnectNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUIScreenDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUIScreenChange:) name:UIScreenModeDidChangeNotification object:nil];

    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	[self showAlertViewForModeSelect];

    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[externalViewController release];
    [viewController release];
    [window release];
	[externalWindow release];
    [super dealloc];
}


@end
