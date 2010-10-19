//
//  UITableViewHacksAppDelegate.h
//  UITableViewHacks
//
//  Created by sonson on 10/03/11.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

@interface UITableViewHacksAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

