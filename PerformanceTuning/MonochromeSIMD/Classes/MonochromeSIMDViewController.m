//
//  MonochromeSIMDViewController.m
//  MonochromeSIMD
//
//  Created by Motohiro Takayama on 8/9/10.
//
//    based on the code from http://journal.mycom.co.jp/column/iphone/004/index.html .

/*
 Original Copyright:
 
 Author: Makoto Kinoshita
 
 Copyright 2009 HMDT Co., Ltd. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted 
 provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of conditions 
 and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list of 
 conditions and the following disclaimer in the documentation and/or other materials provided 
 with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE SHIIRA PROJECT ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
 PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE SHIIRA PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE.
 */

#import "MonochromeSIMDViewController.h"
#import <arm_neon.h>
@implementation MonochromeSIMDViewController

- (void)dealloc
{
   [super dealloc];
}

#define k_LUMINANCE_THRESHOLD 128
#define k_IMAGE_NAME @"IMG_0085.JPG"

void binarize_naive(UInt8 *buf, size_t width, size_t height)
{
   UInt8 *pbuf = buf;

   for (size_t j=0; j < height; j++)
      for (size_t i=0; i < width; i++) {
         UInt8 r = pbuf[0];
         UInt8 g = pbuf[1];
         UInt8 b = pbuf[2];
         UInt8 y = (77 * r + 28 * g + 151 * b) / 256;
         UInt8 binary = y > k_LUMINANCE_THRESHOLD ? 255 : 0; // 二値化
         
         *pbuf++ = binary;
         *pbuf++ = binary;
         *pbuf++ = binary;
         pbuf++;
      }
}

void binarize_gcd1(UInt8 *buf, size_t width, size_t height)
{
   dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

//   for (size_t j=0; j < height; j++) {
   for (size_t j=0; j < 2; j++) {
      dispatch_async(q, ^(void) {
         UInt8 *pbuf = buf + width*j;
         for (size_t i=0; i < width; i++) {
            UInt8 r = pbuf[0];
            UInt8 g = pbuf[1];
            UInt8 b = pbuf[2];
            UInt8 y = (77 * r + 28 * g + 151 * b) / 256;
            UInt8 binary = y > k_LUMINANCE_THRESHOLD ? 255 : 0; // 二値化
            
            *pbuf++ = binary;
            *pbuf++ = binary;
            *pbuf++ = binary;
            pbuf++;
         }
      });
   }
}

void binarize_gcd(UInt8 *buf, size_t width, size_t height)
{
   dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   dispatch_apply(height, q, ^(size_t j) {
      UInt8 *pbuf = buf + width*j*4;
      for (size_t i=0; i < width; i++) {
         UInt8 r = pbuf[0];
         UInt8 g = pbuf[1];
         UInt8 b = pbuf[2];
         UInt8 y = (77 * r + 28 * g + 151 * b) / 256;
         UInt8 binary = y > k_LUMINANCE_THRESHOLD ? 255 : 0; // 二値化
         
         *pbuf++ = binary;
         *pbuf++ = binary;
         *pbuf++ = binary;
         pbuf++;
      }
   });
}

void binarize_SIMD_neon(UInt8 *buf, size_t width, size_t height)
{
   UInt8 *pbuf = buf;

   uint16x8_t rc = vdupq_n_u16(77);
   uint16x8_t gc = vdupq_n_u16(28);
   uint16x8_t bc = vdupq_n_u16(151);
   uint16x8_t threshold = vdupq_n_u16(k_LUMINANCE_THRESHOLD);

   for (size_t j=0; j < height; j++)
      for (size_t i=0; i < width/8; i++) {
         uint16x8_t r = {pbuf[0], pbuf[4], pbuf[8], pbuf[12], pbuf[16], pbuf[20], pbuf[24], pbuf[28]};
         uint16x8_t g = {pbuf[1], pbuf[5], pbuf[9], pbuf[13], pbuf[17], pbuf[21], pbuf[25], pbuf[29]};
         uint16x8_t b = {pbuf[2], pbuf[6], pbuf[10], pbuf[14], pbuf[18], pbuf[22], pbuf[26], pbuf[30]};
         
         uint16x8_t y = r*rc;
         y           += g*gc;
         y           += b*bc;
         y            = vshrq_n_u16(y, 8); // y /= 256
         
         uint16x8_t compared  = vcgtq_u16(y, threshold); // 二値化
         UInt8 *pbinary = (UInt8 *)&compared;
         
         pbuf[0]  = pbuf[1]  = pbuf[2]  = *pbinary++;
         pbuf[4]  = pbuf[5]  = pbuf[6]  = *pbinary++;
         pbuf[8]  = pbuf[9]  = pbuf[10] = *pbinary++;
         pbuf[12] = pbuf[13] = pbuf[14] = *pbinary++;
         pbuf[16] = pbuf[17] = pbuf[18] = *pbinary++;
         pbuf[20] = pbuf[21] = pbuf[22] = *pbinary++;
         pbuf[24] = pbuf[25] = pbuf[26] = *pbinary++;
         pbuf[28] = pbuf[29] = pbuf[30] = *pbinary++;

         pbuf += 32;
      }
}

void binarize_SIMD_vfp(UInt8 *buf, size_t width, size_t height)
{
}

- (void) getBitmap:(UInt8 **)bitmap width:(size_t *)width height:(size_t *)height data:(CFDataRef *)data
{
   UIImage *originalImage = [UIImage imageNamed:k_IMAGE_NAME];
   CGImageRef cgImage = [originalImage CGImage];
   
   size_t                  bitsPerComponent;
   size_t                  bitsPerPixel;
   size_t                  bytesPerRow;
   CGColorSpaceRef         colorSpace;
   CGBitmapInfo            bitmapInfo;
   bool                    shouldInterpolate;
   CGColorRenderingIntent  intent;
   *width = CGImageGetWidth(cgImage);
   *height = CGImageGetHeight(cgImage);
   bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
   bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
   bytesPerRow = CGImageGetBytesPerRow(cgImage);
   colorSpace = CGImageGetColorSpace(cgImage);
   bitmapInfo = CGImageGetBitmapInfo(cgImage);
   shouldInterpolate = CGImageGetShouldInterpolate(cgImage);
   intent = CGImageGetRenderingIntent(cgImage);
   
   CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
   *data = CGDataProviderCopyData(dataProvider);
   *bitmap = (UInt8*)CFDataGetBytePtr(*data);
}

- (void) storeResult:(UInt8 *)bitmap data:(CFDataRef)data
{
   UIImage *originalImage = [UIImage imageNamed:k_IMAGE_NAME];
   CGImageRef cgImage = [originalImage CGImage];
   
   size_t                  width, height;
   size_t                  bitsPerComponent;
   size_t                  bitsPerPixel;
   size_t                  bytesPerRow;
   CGColorSpaceRef         colorSpace;
   CGBitmapInfo            bitmapInfo;
   bool                    shouldInterpolate;
   CGColorRenderingIntent  intent;
   width = CGImageGetWidth(cgImage);
   height = CGImageGetHeight(cgImage);
   bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
   bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
   bytesPerRow = CGImageGetBytesPerRow(cgImage);
   colorSpace = CGImageGetColorSpace(cgImage);
   bitmapInfo = CGImageGetBitmapInfo(cgImage);
   shouldInterpolate = CGImageGetShouldInterpolate(cgImage);
   intent = CGImageGetRenderingIntent(cgImage);
   
   CFDataRef effectedData = CFDataCreate(NULL, bitmap, CFDataGetLength(data));
   CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
   
   CGImageRef effectedCgImage = CGImageCreate(width, height, 
                                              bitsPerComponent, bitsPerPixel, bytesPerRow, 
                                              colorSpace, bitmapInfo, effectedDataProvider, 
                                              NULL, shouldInterpolate, intent);
   UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
   
    imageView.image = effectedImage;
   [effectedImage release];
   
   CGImageRelease(effectedCgImage);
   CFRelease(effectedDataProvider);
   CFRelease(effectedData);
   CFRelease(data);
}

- (IBAction) convertNaive
{
   UInt8 *bitmap = NULL;
   size_t width, height;
   CFDataRef data;
   [self getBitmap:&bitmap width:&width height:&height data:&data];

   NSDate *from = [NSDate date];
   binarize_naive(bitmap, width, height);
   NSDate *to = [NSDate date];
   resultLabel.text = [NSString stringWithFormat:@"%f", [to timeIntervalSinceDate:from]];
   
   [self storeResult:bitmap data:data];
}

- (IBAction) convertSIMD
{
   UInt8 *bitmap = NULL;
   size_t width, height;
   CFDataRef data;
   [self getBitmap:&bitmap width:&width height:&height data:&data];
   
   NSDate *from = [NSDate date];
   binarize_SIMD_neon(bitmap, width, height);
   NSDate *to = [NSDate date];
   resultLabel.text = [NSString stringWithFormat:@"%f", [to timeIntervalSinceDate:from]];
   
   [self storeResult:bitmap data:data];
}

- (IBAction) convertGCD
{
   UInt8 *bitmap = NULL;
   size_t width, height;
   CFDataRef data;
   [self getBitmap:&bitmap width:&width height:&height data:&data];
   
   NSDate *from = [NSDate date];
   binarize_gcd(bitmap, width, height);
   NSDate *to = [NSDate date];
   resultLabel.text = [NSString stringWithFormat:@"%f", [to timeIntervalSinceDate:from]];
   
   [self storeResult:bitmap data:data];
}

@end