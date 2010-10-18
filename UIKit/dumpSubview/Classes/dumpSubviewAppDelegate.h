//
//  dumpSubviewAppDelegate.h
//  dumpSubview
//
//  Created by sonson on 09/04/02.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class dumpSubviewViewController;

@interface dumpSubviewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    dumpSubviewViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet dumpSubviewViewController *viewController;

@end

