//
//  MonochromeSIMDAppDelegate.h
//  MonochromeSIMD
//
//  Created by Motohiro Takayama on 8/9/10.
//  Copyright deadbeaf.org 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MonochromeSIMDViewController;

@interface MonochromeSIMDAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow *window;
    MonochromeSIMDViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MonochromeSIMDViewController *viewController;

@end