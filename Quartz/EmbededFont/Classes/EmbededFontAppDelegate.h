//
//  EmbededFontAppDelegate.h
//  EmbededFont
//
//  Created by sonson on 09/09/02.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmbededFontViewController;

@interface EmbededFontAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EmbededFontViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EmbededFontViewController *viewController;

@end

