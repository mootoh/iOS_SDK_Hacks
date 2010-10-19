//
//  TestView.m
//  EmbededFont
//
//  Created by sonson on 09/09/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestView.h"

#import "fontTableConverter.h"

CGFontRef embededFont = NULL;
fontTable* tbl = NULL;

#define _DONOT_USE_PRIVATE_API

#ifdef _DONOT_USE_PRIVATE_API
#else
extern void CGFontGetGlyphsForUnichars(CGFontRef, const UniChar[], const CGGlyph[], size_t);
#endif

@implementation TestView

- (void)awakeFromNib {
	if (embededFont == NULL) {
		// Get the path to our custom font and create a data provider.
		NSString *fontPath = [[NSBundle mainBundle] pathForResource:@"mona" ofType:@"ttf"]; 
		CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
		
		// Create the font with the data provider, then release the data provider.
		embededFont = CGFontCreateWithDataProvider(fontDataProvider);
#ifdef _DONOT_USE_PRIVATE_API
		tbl = readFontTableFromCGFont(embededFont);
#endif		
		CGDataProviderRelease(fontDataProvider); 
	}
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFont(context, embededFont);
	CGContextSetFontSize(context, 10);
	
	NSString *texts[10];
	texts[0] = @"　　　　ビシッ　　／￣￣￣￣＼";
	texts[1] = @"　　　 ／￣＼（　　人＿＿＿＿）";
	texts[2] = @"　 ,　┤　　　 ト|ミ/　 ー◎-◎-）";
	texts[3] = @"　|　　＼＿／　 ヽ　　　　(_　_)　） フォント埋め込んだか？";
#ifdef _DONOT_USE_PRIVATE_API
	texts[4] = @"　|　　　＿_（￣　｜∴ノ　　３　ノ　これはPrivate APIを使ってないぞ";
#else
	texts[4] = @"　|　　　＿_（￣　｜∴ノ　　３　ノ　これはPrivate APIを使ってるぞ";
#endif
	texts[5] = @"　|　　　 ＿_）＿ノ ヽ　　　　　ノ 　";
	texts[6] = @"　ヽ＿＿＿） ノ 　　　））　　　ヽ.";
	
	for (int i = 0; i < 7; i++) {
		size_t griphLen = 0;
		NSString *text = texts[i];
		NSInteger length = [text length];
		unichar *chars = (unichar*)malloc(sizeof(unichar) * length);
		[text getCharacters:chars];
		CGGlyph *glyphs = (CGGlyph*)malloc(sizeof(CGGlyph) * length);
		CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1, -1));
#ifdef _DONOT_USE_PRIVATE_API
		mapCharactersToGlyphsInFont(tbl, chars, length, glyphs, &griphLen);
#else
		CGFontGetGlyphsForUnichars(embededFont, chars, glyphs, length);
		griphLen = length;
#endif
		CGPoint point = {10, 30 + 10*i};
		CGContextShowGlyphsAtPoint(context, point.x, point.y, glyphs, griphLen);
	}
}

- (void)dealloc {
    [super dealloc];
}

@end
