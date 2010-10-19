//
//  fontTableConverter.h
//  EmbededFont
//
//  Created by sonson on 10/06/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kFontTableFormat4 = 4,
    kFontTableFormat12 = 12,
} FontTableFormat;

typedef struct fontTable {
    CFDataRef cmapTable;
    FontTableFormat format;
    union {
        struct {
            UInt16 segCountX2;
            UInt16 *endCodes;
            UInt16 *startCodes;
            UInt16 *idDeltas;
            UInt16 *idRangeOffsets;
        } format4;
        struct {
            UInt32 nGroups;
            struct {
                UInt32 startCharCode;
                UInt32 endCharCode;
                UInt32 startGlyphCode;
            } *groups;
        } format12;
    } cmap;
} fontTable;

fontTable *newFontTable(CFDataRef cmapTable, FontTableFormat format);

void freeFontTable(fontTable *table);

fontTable *readFontTableFromCGFont(CGFontRef font);

void mapCharactersToGlyphsInFont(const fontTable *table, unichar characters[], size_t charLen, CGGlyph outGlyphs[], size_t *outGlyphLen);