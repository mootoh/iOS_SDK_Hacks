//
//  TextGlyphView.m
//  textGlyph
//
//  Created by sonson on 09/05/06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TextGlyphView.h"

extern void CGFontGetGlyphsForUnichars (CGFontRef font, const unichar* chars, const CGGlyph* glyphs, size_t length);

@implementation TextGlyphView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		NSString* fontName = @"HiraKakuProN-W3";
		font = CGFontCreateWithFontName((CFStringRef)fontName);
		self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawSentence {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetFont(ctx, font);
	CGContextSetFontSize(ctx, 20);
	CGContextSetTextDrawingMode(ctx, kCGTextFill);
	CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
	CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1, -1));
	
	NSString *text = @"Hello world";
	NSInteger length = [text length];
	unichar *chars = (unichar*)malloc(sizeof(unichar) * length);
	[text getCharacters:chars];
	CGGlyph *glyphs = (CGGlyph*)malloc(sizeof(CGGlyph) * length);
	CGFontGetGlyphsForUnichars(font, chars, glyphs, length);
	float x = 10;
	float y = 40;
	CGContextShowGlyphsAtPoint(ctx, x, y, glyphs, length);
	CGPoint point = CGContextGetTextPosition(ctx);
	// 119.82, 40
}

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetFont(ctx, font);
	CGContextSetFontSize(ctx, 20);
	CGContextSetTextDrawingMode(ctx, kCGTextFill);
	CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
	CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1, -1));
	
	NSString *text = @"Hello world";
	NSInteger length = [text length];
	unichar *chars = (unichar*)malloc(sizeof(unichar) * length);
	[text getCharacters:chars];
	CGGlyph *glyphs = (CGGlyph*)malloc(sizeof(CGGlyph) * length);
	CGFontGetGlyphsForUnichars(font, chars, glyphs, length);

	CGPoint point = {10, 40};
	for( int i = 0; i < length; i++) {
		CGContextShowGlyphsAtPoint(ctx, point.x, point.y, glyphs + i, 1);
		point = CGContextGetTextPosition(ctx);
	}
}

- (void)dealloc {
	CGFontRelease(font);
    [super dealloc];
}


@end
