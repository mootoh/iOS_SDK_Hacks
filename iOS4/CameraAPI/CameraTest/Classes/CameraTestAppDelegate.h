//
//  CameraTestAppDelegate.h
//  CameraTest
//
//  Created by sonson on 10/06/25.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraTestViewController;

@interface CameraTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CameraTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CameraTestViewController *viewController;

@end

