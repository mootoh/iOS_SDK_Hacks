//
//  ClippingView.m
//  clipping
//
//  Created by sonson on 09/05/06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ClippingView.h"

@implementation ClippingView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor whiteColor];
		pict = [UIImage imageNamed:@"pict.png"];
		[pict retain];
    }
    return self;
}

- (void)drawRoundCornerPictAtPoint:(CGPoint)point {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect imageRect = {point.x, point.y, 120, 160};
	float radius = 10;
	
	// get points
	CGFloat minx = CGRectGetMinX( imageRect ), midx = CGRectGetMidX( imageRect ), maxx = CGRectGetMaxX( imageRect );
	CGFloat miny = CGRectGetMinY( imageRect ), midy = CGRectGetMidY( imageRect ), maxy = CGRectGetMaxY( imageRect );
	
	CGContextSaveGState(context);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextClip(context);
	
	[pict drawInRect:imageRect];
	CGContextRestoreGState(context);
}

- (void)drawShadowAtPoint:(CGPoint)point {

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect imageRect = {point.x, point.y, 120, 160};
	float radius = 10;
	
	// get points
	CGFloat minx = CGRectGetMinX( imageRect ), midx = CGRectGetMidX( imageRect ), maxx = CGRectGetMaxX( imageRect );
	CGFloat miny = CGRectGetMinY( imageRect ), midy = CGRectGetMidY( imageRect ), maxy = CGRectGetMaxY( imageRect );
	
	CGContextSaveGState(context);
	
	UIColor *blackColor = [UIColor blackColor];
	CGContextSetShadowWithColor (context, CGSizeMake(0, -1), 2.0, [blackColor CGColor]);
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextFillPath(context);
	
	CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect {
	[self drawShadowAtPoint:CGPointMake(100, 230)];
	[self drawRoundCornerPictAtPoint:CGPointMake(100, 230)];
	
	[self drawRoundCornerPictAtPoint:CGPointMake(100, 40)];
}

- (void)dealloc {
	[pict release];
    [super dealloc];
}


@end
