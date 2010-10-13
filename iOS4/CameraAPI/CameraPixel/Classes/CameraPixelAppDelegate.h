//
//  CameraPixelAppDelegate.h
//  CameraPixel
//
//  Created by sonson on 10/06/26.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface CameraPixelAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	RootViewController *rootController;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@end

