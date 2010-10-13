//
//  CameraViewController.h
//  CameraPixel
//
//  Created by sonson on 10/06/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCEAGLView;

@interface CameraViewController : UIViewController {
	UIActivityIndicatorView *indicator;
	CCEAGLView *glview;
}

@end
