//
//  CameraController.h
//  CameraTest
//
//  Created by sonson on 10/06/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CCCameraController : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate> {
	AVCaptureSession				*session;
	CGSize							frameSize;
	AVCaptureVideoPreviewLayer		*previewLayer;
	unsigned char					*pixelBuffer;
}
- (AVCaptureSession*)session;
- (CGSize)frameSize;
- (void)start;
- (void)stop;
- (id)initWithSessionPreset:(NSString*)sessionPresetString;
- (unsigned char*)pixelBuff;
@end
