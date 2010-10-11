//
//  pnsAppDelegate.h
//  pns
//
//  Created by sonson on 09/11/14.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class pnsViewController;

@interface pnsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    pnsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet pnsViewController *viewController;

@end

