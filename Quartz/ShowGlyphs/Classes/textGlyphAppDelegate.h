//
//  textGlyphAppDelegate.h
//  textGlyph
//
//  Created by sonson on 09/05/06.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class textGlyphViewController;

@interface textGlyphAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    textGlyphViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet textGlyphViewController *viewController;

@end

