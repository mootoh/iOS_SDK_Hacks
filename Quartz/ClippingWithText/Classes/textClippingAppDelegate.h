//
//  textClippingAppDelegate.h
//  textClipping
//
//  Created by sonson on 09/05/06.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class textClippingViewController;

@interface textClippingAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    textClippingViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet textClippingViewController *viewController;

@end

