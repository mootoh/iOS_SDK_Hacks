//
//  pnsAppDelegate.m
//  pns
//
//  Created by sonson on 09/11/14.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "pnsAppDelegate.h"
#import "pnsViewController.h"

@implementation pnsAppDelegate

@synthesize window;
@synthesize viewController;

#pragma mark -
#pragma mark Alert

- (void)showAlertWithText:(NSString*)text {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:text 
												   delegate:nil 
										  cancelButtonTitle:nil 
										  otherButtonTitles:@"OK", nil];
	[alert show];
	[alert autorelease];
}

#pragma mark -
#pragma mark PushNotification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
	NSString* deviceTokenString = [NSString stringWithFormat:@"%@", deviceToken];
	NSString* sent = [deviceTokenString substringWithRange:NSMakeRange( 1, [deviceTokenString length]-2)];
	NSLog(@"%@", sent);
	[[NSUserDefaults standardUserDefaults] setObject:sent forKey:@"deviceToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	[self showAlertWithText:[error localizedDescription]];
}

#pragma -
#pragma mark Override

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Push Notificationで受け取ったデータをNSDictionaryで取得
	NSDictionary *pnsDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
	if (pnsDict) {
		NSString *text = [NSString stringWithFormat:@"%@", [pnsDict objectForKey:@"data"]];
		[self showAlertWithText:text];
		[self applicationDidFinishLaunching:application];
		return YES;
	}
	else {
		[self applicationDidFinishLaunching:application];
		return NO;
	}
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
#if TARGET_IPHONE_SIMULATOR
	// iPhoneシミュレータ上ではPushNotificationは動かないので，ダミーdeviceTokenを発行
	[[NSUserDefaults standardUserDefaults] setObject:@"XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX" forKey:@"deviceToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
#else
	// Push Notification
	NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
	if (![deviceToken length]) {
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
	}
#endif
	
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
