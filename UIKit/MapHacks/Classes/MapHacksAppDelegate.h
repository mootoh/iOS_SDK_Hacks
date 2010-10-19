//
//  MapHacksAppDelegate.h
//  MapHacks
//
//  Created by sonson on 09/08/30.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapHacksViewController;

@interface MapHacksAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MapHacksViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MapHacksViewController *viewController;

@end

