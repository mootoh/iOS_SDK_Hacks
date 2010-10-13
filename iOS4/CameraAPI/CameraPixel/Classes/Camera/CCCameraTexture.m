//
//  CameraTexture.m
//  CameraPixel
//
//  Created by sonson on 10/06/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CCCameraTexture.h"

@interface CCCameraTexture(private)
-(void)initTexture;
@end

@implementation CCCameraTexture

- (GLuint)textureHandle {
	if (textureHandle == 0) {
		[self initTexture];
	}
	return textureHandle;
}

#pragma mark -
#pragma mark Private Instance method

int  getY(int r, int b, int g) {
	int  y =
		( ( 306 * (int)r+ 512 ) >> 10 )
		+ ( ( 601 * (int)g + 512 ) >> 10 )
		+ ( ( 117 * (int)b + 512 ) >> 10 );
	if ( y < 0x00 )  y = 0x00;
	if ( y > 0xFF )  y = 0xFF;
	return  y;
}

- (void)initTexture {
	int w = frameSize.width;
	int h = frameSize.height;
	int dataSize = w * h * 4;
	uint8_t* textureData = (uint8_t*)malloc(dataSize);
	if(textureData == NULL)
		return;
	memset(textureData, 128, dataSize);
	
	GLuint handle;
	glGenTextures(1, &handle);
	glBindTexture(GL_TEXTURE_2D, handle);
	glTexParameterf(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_FALSE);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_BGRA_EXT, GL_UNSIGNED_BYTE, textureData);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glBindTexture(GL_TEXTURE_2D, 0);
	textureHandle = handle;
	free(textureData);
}

#pragma mark -
#pragma mark AVCaptureAudioDataOutputSampleBufferDelegate

// #define _PIXEL_COPYING

#ifdef _PIXEL_COPYING
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
	if ([session isRunning]) {
		CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
		size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
		size_t height = CVPixelBufferGetHeight(imageBuffer); 
		CVPixelBufferLockBaseAddress(imageBuffer, 0);
		unsigned char* linebase = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
		glBindTexture(GL_TEXTURE_2D, [self textureHandle]);
		memcpy([self pixelBuff], linebase, sizeof(unsigned char) * bytesPerRow * height);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, frameSize.width, frameSize.height, GL_BGRA_EXT, GL_UNSIGNED_BYTE, linebase);
		CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
	}
}
#else
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
	if ([session isRunning]) {
		CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
		CVPixelBufferLockBaseAddress(imageBuffer, 0);
		unsigned char* linebase = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
		glBindTexture(GL_TEXTURE_2D, [self textureHandle]);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, frameSize.width, frameSize.height, GL_BGRA_EXT, GL_UNSIGNED_BYTE, linebase);
		CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
	}
}
#endif

@end
