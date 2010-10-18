//
//  NSOperationTestAppDelegate.h
//  NSOperationTest
//
//  Created by sonson on 10/03/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

@interface NSOperationTestAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

