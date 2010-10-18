//
//  clippingAppDelegate.h
//  clipping
//
//  Created by sonson on 09/05/06.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class clippingViewController;

@interface clippingAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    clippingViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet clippingViewController *viewController;

@end

