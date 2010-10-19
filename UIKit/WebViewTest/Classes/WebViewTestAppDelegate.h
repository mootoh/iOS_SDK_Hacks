//
//  WebViewTestAppDelegate.h
//  WebViewTest
//
//  Created by sonson on 09/11/24.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebViewTestViewController;

@interface WebViewTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    WebViewTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet WebViewTestViewController *viewController;

@end

