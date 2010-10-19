//
//  respondToSelectorAppDelegate.h
//  respondToSelector
//
//  Created by sonson on 09/04/08.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class respondToSelectorViewController;

@interface respondToSelectorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    respondToSelectorViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet respondToSelectorViewController *viewController;

@end

