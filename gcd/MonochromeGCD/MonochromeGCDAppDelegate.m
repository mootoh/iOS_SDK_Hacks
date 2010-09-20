//
//  MonochromeGCDAppDelegate.m
//  MonochromeGCD
//
//  Created by Motohiro Takayama on 8/21/10.
//

#import "MonochromeGCDAppDelegate.h"

@implementation MonochromeGCDAppDelegate

@synthesize window;

#define k_LUMINANCE_THRESHOLD 128
#define k_IMAGE_NAME @"pic.jpg"

void binarize_naive(UInt8 *buf, size_t width, size_t height)
{
   for (size_t j=0; j < height; j++) {
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
   }
}

void binarize_gcd(UInt8 *buf, size_t width, size_t height)
{
   dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   dispatch_apply(height, q, ^(size_t j) {
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

- (void) getBitmap:(UInt8 **)bitmap width:(size_t *)width height:(size_t *)height data:(CFDataRef *)data
{
   NSImage *originalImage = [NSImage imageNamed:k_IMAGE_NAME];
   NSGraphicsContext *context = [NSGraphicsContext currentContext];

   CGImageRef cgImage = [originalImage CGImageForProposedRect:NULL context:context hints:nil];
   
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

- (IBAction) convert
{
   UInt8 *bitmap = NULL;
   size_t width, height;
   CFDataRef data;
   [self getBitmap:&bitmap width:&width height:&height data:&data];
   
   NSDate *from = [NSDate date];
   binarize_naive(bitmap, width, height);
   NSDate *to = [NSDate date];
   NSLog(@"naive: %@",[NSString stringWithFormat:@"%f", [to timeIntervalSinceDate:from]]);

   [self getBitmap:&bitmap width:&width height:&height data:&data];

   NSDate *from2 = [NSDate date];
   binarize_gcd(bitmap, width, height);
   NSDate *to2 = [NSDate date];
   NSLog(@"gcd %@",[NSString stringWithFormat:@"%f", [to2 timeIntervalSinceDate:from2]]);
   
   //[self storeResult:bitmap data:data];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
   [self convert];
}

@end
