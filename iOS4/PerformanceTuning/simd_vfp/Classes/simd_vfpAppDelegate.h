//
//  simd_vfpAppDelegate.h
//  simd_vfp
//
//  Created by Motohiro Takayama on 8/5/10.
//  Copyright Personal 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class simd_vfpViewController;

@interface simd_vfpAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow *window;
    simd_vfpViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet simd_vfpViewController *viewController;

@end

