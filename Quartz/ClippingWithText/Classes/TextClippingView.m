//
//  TextClippingView.m
//  textClipping
//
//  Created by sonson on 09/05/06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TextClippingView.h"

extern void CGFontGetGlyphsForUnichars (CGFontRef font, const unichar* chars, const CGGlyph* glyphs, size_t length);

@implementation TextClippingView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor whiteColor];
		pict = [UIImage imageNamed:@"pict.png"];
		[pict retain];
		NSString* fontName = @"HiraKakuProN-W6";
		font = CGFontCreateWithFontName((CFStringRef)fontName);
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetFont(ctx, font);
	CGContextSetFontSize(ctx, 50);
	CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
	CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1, -1));
	
	int mode[4];
	mode[0] = kCGTextClip;
	mode[1] = kCGTextFillClip;
	mode[2] = kCGTextStrokeClip;
	mode[3] = kCGTextFillStrokeClip;

	for (int i = 0; i < 4; i++) {
		
		CGRect imageRect = {10, 60 + 100 * i, 80, 80};
		CGContextSetTextDrawingMode(ctx, mode[i]);
		CGContextSaveGState(ctx);
		NSString *text = @"Hello world";
		NSInteger length = [text length];
		unichar *chars = (unichar*)malloc(sizeof(unichar) * length);
		[text getCharacters:chars];
		CGGlyph *glyphs = (CGGlyph*)malloc(sizeof(CGGlyph) * length);
		CGFontGetGlyphsForUnichars(font, chars, glyphs, length);
		float x = 10;
		float y = 100 + 100 * i;
		CGContextShowGlyphsAtPoint(ctx, x, y, glyphs, length);
		[pict drawInRect:imageRect];
		CGContextRestoreGState(ctx);
	}
	
}


- (void)dealloc {
    [super dealloc];
}


@end
