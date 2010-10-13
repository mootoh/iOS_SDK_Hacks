//
//  CameraViewController.h
//  CameraTest
//
//  Created by sonson on 10/06/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CameraController;
@class AVCaptureVideoPreviewLayer;

@interface CameraViewController : UIViewController {
	CameraController			*camera;
	AVCaptureVideoPreviewLayer	*previewLayer;
}
+ (UINavigationController*)navigationController;
@end
