//
//  MonochromeSIMDViewController.h
//  MonochromeSIMD
//
//  Created by Motohiro Takayama on 8/9/10.
//  Copyright deadbeaf.org 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonochromeSIMDViewController : UIViewController
{
   IBOutlet UILabel *resultLabel;
   IBOutlet UIImageView *imageView;
}

- (IBAction) convertNaive;
- (IBAction) convertSIMD;
- (IBAction) convertGCD;

@end