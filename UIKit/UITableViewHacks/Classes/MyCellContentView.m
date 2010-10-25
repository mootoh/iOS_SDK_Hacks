//
//  MyCellContentView.m
//  UITableViewHacks
//
//  Created by sonson on 10/03/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyCellContentView.h"
#import "Content.h"
#import "MyTableViewCell.h"

BOOL drawDebugFrame = NO;

@implementation MyCellContentView

@dynamic highlighted;

+ (void)setDrawDebugFrame:(BOOL)newValue {
	drawDebugFrame = newValue;
}

+ (BOOL)drawDebugFrame {
	return drawDebugFrame;
}

- (id)initWithFrame:(CGRect)frame withCell:(MyTableViewCell*)newcell {
    if (self = [super initWithFrame:frame]) {
		cell = newcell;
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setHighlighted:(BOOL)newValue {
	// when touched cell
    highlighted = newValue;
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame {
	// when pushed edit button 
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	// draw view area
	if (drawDebugFrame) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		[[UIColor colorWithRed:1 green:0 blue:0 alpha:0.1] setFill];
		[[UIColor colorWithRed:1 green:0 blue:0 alpha:1] setStroke];
		CGContextSetLineWidth(context, 2);
		CGContextFillRect(context, rect);
		CGContextStrokeRect(context, rect);
	}
	
	// draw icon
	float y = (int)(rect.size.height - cell.content.icon.size.height)/2;
	[cell.content.icon drawAtPoint:CGPointMake(10, y)];
	
	// draw title
	if (highlighted)
		[[UIColor whiteColor] setFill];
	else
		[[UIColor blackColor] setFill];
	float str_x = 10 + cell.content.icon.size.width + 10;
	CGRect str_rect = rect;
	str_rect.origin.x = str_x;
	str_rect.size.width = rect.size.width - str_x;
	[cell.content.title drawInRect:str_rect withFont:[UIFont systemFontOfSize:18.0] lineBreakMode:UILineBreakModeTailTruncation];
}

- (void)dealloc {
    [super dealloc];
}

@end
