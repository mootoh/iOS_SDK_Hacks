//
//  CameraController.m
//  CameraTest
//
//  Created by sonson on 10/06/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CCCameraController.h"

@interface CCCameraController(private)
- (BOOL)updateFrameSizeWithSessionPreset:(NSString*)sessionPresetString;
- (BOOL)setupCameraWithSessionPreset:(NSString*)sessionPresetString;
@end

@implementation CCCameraController

#pragma mark -
#pragma mark Private Instance method

- (BOOL)updateFrameSizeWithSessionPreset:(NSString*)sessionPresetString {
	if ([sessionPresetString isEqualToString:AVCaptureSessionPreset1280x720]) {
		frameSize = CGSizeMake(1280, 720);
		return YES;
	}
	else if ([sessionPresetString isEqualToString:AVCaptureSessionPreset640x480]) {
		frameSize = CGSizeMake(640, 480);
		return YES;
	}
	else if ([sessionPresetString isEqualToString:AVCaptureSessionPresetHigh]) {
		frameSize = CGSizeMake(640, 480);
		return YES;
	}
	else if ([sessionPresetString isEqualToString:AVCaptureSessionPresetMedium]) {
		frameSize = CGSizeMake(480, 360);
		return YES;
	}
	else if ([sessionPresetString isEqualToString:AVCaptureSessionPresetLow]) {
		frameSize = CGSizeMake(192, 144);
		return YES;
	}
	return NO;
}

- (BOOL)setupCameraWithSessionPreset:(NSString*)sessionPresetString {
	NSError *error = nil;
	
	// make capture session
	session = [[AVCaptureSession alloc] init];
	
	// get default video device
	AVCaptureDevice * videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	
	// setup video input
	AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
	
	// setup video output
	NSDictionary *settingInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
	AVCaptureVideoDataOutput * videoDataOutput = [[[AVCaptureVideoDataOutput alloc] init] autorelease];
	[videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
	[videoDataOutput setVideoSettings:settingInfo];	
	[videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
	
	// attach video to session
	[session beginConfiguration];
	[session addInput:videoInput];
	[session addOutput:videoDataOutput];
	[session setSessionPreset:sessionPresetString];
	[session commitConfiguration];
	
	return YES;
}

#pragma mark -
#pragma mark Instance method

- (AVCaptureSession*)session {
	return session;
}

- (CGSize)frameSize {
	return frameSize;
}

- (void)start {
	[session startRunning];
}

- (void)stop {
	[session stopRunning];
}

- (id)initWithSessionPreset:(NSString*)sessionPresetString {
	if (self = [super init]) {
		if (![self updateFrameSizeWithSessionPreset:sessionPresetString]) {
			[self autorelease];
			return nil;
		}
		if (![self setupCameraWithSessionPreset:sessionPresetString]) {
			[self autorelease];
			return nil;
		}
	}
	return self;
}

- (unsigned char*)pixelBuff {
	if (pixelBuffer == nil) {
		pixelBuffer = (unsigned char*)malloc(sizeof(unsigned char) * frameSize.width * frameSize.height * 4);
		for (int x = 0; x < frameSize.width; x++) {
			for (int y = 0; y < frameSize.height; y++) {
			//	*(pixelBuffer + x * 4 + y * (int)frameSize.width * 4 + 0 ) = 255;
			//	*(pixelBuffer + x * 4 + y * (int)frameSize.width * 4 + 1 ) = 0;
			//	*(pixelBuffer + x * 4 + y * (int)frameSize.width * 4 + 2 ) = 0;
			//	*(pixelBuffer + x * 4 + y * (int)frameSize.width * 4 + 3 ) = 255;
			}
		}
	}
	
	return pixelBuffer;
}

#pragma mark -
#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
	DNSLogMethod
	if ([session isRunning]) {
		CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
		size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
		size_t height = CVPixelBufferGetHeight(imageBuffer); 
		CVPixelBufferLockBaseAddress(imageBuffer, 0);
		unsigned char* linebase = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
		memcpy([self pixelBuff], linebase, sizeof(unsigned char) * bytesPerRow * height);
		CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
	}
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc {
	DNSLogMethod
	[session stopRunning];
	[session release];
	SAFE_FREE(pixelBuffer);
	[super dealloc];
}

@end
