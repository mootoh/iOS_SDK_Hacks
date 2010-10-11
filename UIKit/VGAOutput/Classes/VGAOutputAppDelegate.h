//
//  VGAOutputAppDelegate.h
//  VGAOutput
//
//  Created by sonson on 10/09/14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VGAOutputViewController;
@class ExternalViewController;

@interface VGAOutputAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIWindow *externalWindow;
    VGAOutputViewController *viewController;
	ExternalViewController	*externalViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIWindow *externalWindow;
@property (nonatomic, retain) IBOutlet VGAOutputViewController *viewController;
@property (nonatomic, retain) IBOutlet ExternalViewController *externalViewController;

@end

