//
//  fontTableConverter.m
//  EmbededFont
//
//  Created by sonson on 10/06/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "fontTableConverter.h"

#define kUnicodeHighSurrogateStart 0xD800
#define kUnicodeHighSurrogateEnd 0xDBFF
#define kUnicodeLowSurrogateStart 0xDC00
#define kUnicodeLowSurrogateEnd 0xDFFF
#define UnicharIsHighSurrogate(c) (c >= kUnicodeHighSurrogateStart && c <= kUnicodeHighSurrogateEnd)
#define UnicharIsLowSurrogate(c) (c >= kUnicodeLowSurrogateStart && c <= kUnicodeLowSurrogateEnd)
#define ConvertSurrogatePairToUTF32(high, low) ((UInt32)((high - 0xD800) * 0x400 + (low - 0xDC00) + 0x10000))


static FontTableFormat supportedFormats[] = { kFontTableFormat4, kFontTableFormat12 };
static size_t supportedFormatsCount = sizeof(supportedFormats) / sizeof(FontTableFormat);

fontTable *newFontTable(CFDataRef cmapTable, FontTableFormat format) {
    fontTable *table = (struct fontTable *)malloc(sizeof(struct fontTable));
    table->cmapTable = CFRetain(cmapTable);
    table->format = format;
    return table;
}

void freeFontTable(fontTable *table) {
    if (table != NULL) {
        CFRelease(table->cmapTable);
        free(table);
    }
}

// read the cmap table from the font
// we only know how to understand some of the table formats at the moment
fontTable *readFontTableFromCGFont(CGFontRef font) {
    CFDataRef cmapTable = CGFontCopyTableForTag(font, 'cmap');
    NSCAssert1(cmapTable != NULL, @"CGFontCopyTableForTag returned NULL for 'cmap' tag in font %@",
               (font ? [(id)CFCopyDescription(font) autorelease] : @"(null)"));
    const UInt8 * const bytes = CFDataGetBytePtr(cmapTable);
    NSCAssert1(OSReadBigInt16(bytes, 0) == 0, @"cmap table for font %@ has bad version number",
               (font ? [(id)CFCopyDescription(font) autorelease] : @"(null)"));
    UInt16 numberOfSubtables = OSReadBigInt16(bytes, 2);
    const UInt8 *unicodeSubtable = NULL;
    //UInt16 unicodeSubtablePlatformID;
    UInt16 unicodeSubtablePlatformSpecificID;
    FontTableFormat unicodeSubtableFormat;
    const UInt8 * const encodingSubtables = &bytes[4];
    for (UInt16 i = 0; i < numberOfSubtables; i++) {
        const UInt8 * const encodingSubtable = &encodingSubtables[8 * i];
        UInt16 platformID = OSReadBigInt16(encodingSubtable, 0);
        UInt16 platformSpecificID = OSReadBigInt16(encodingSubtable, 2);
        // find the best subtable
        // best is defined by a combination of encoding and format
        // At the moment we only support format 4, so ignore all other format tables
        // We prefer platformID == 0, but we will also accept Microsoft's unicode format
        if (platformID == 0 || (platformID == 3 && platformSpecificID == 1)) {
            BOOL preferred = NO;
            if (unicodeSubtable == NULL) {
                preferred = YES;
            } else if (platformID == 0 && platformSpecificID > unicodeSubtablePlatformSpecificID) {
                preferred = YES;
            }
            if (preferred) {
                UInt32 offset = OSReadBigInt32(encodingSubtable, 4);
                const UInt8 *subtable = &bytes[offset];
                UInt16 format = OSReadBigInt16(subtable, 0);
                for (int i = 0; i < supportedFormatsCount; i++) {
                    if (format == supportedFormats[i]) {
                        if (format >= 8) {
                            // the version is a fixed-point
                            UInt16 formatFrac = OSReadBigInt16(subtable, 2);
                            if (formatFrac != 0) {
                                // all the current formats with a Fixed version are always *.0
                                continue;
                            }
                        }
                        unicodeSubtable = subtable;
                        //unicodeSubtablePlatformID = platformID;
                        unicodeSubtablePlatformSpecificID = platformSpecificID;
                        unicodeSubtableFormat = format;
                        break;
                    }
                }
            }
        }
    }
    fontTable *table = NULL;
    if (unicodeSubtable != NULL) {
        table = newFontTable(cmapTable, unicodeSubtableFormat);
        switch (unicodeSubtableFormat) {
            case kFontTableFormat4:
                // subtable format 4
                //UInt16 length = OSReadBigInt16(unicodeSubtable, 2);
                //UInt16 language = OSReadBigInt16(unicodeSubtable, 4);
                table->cmap.format4.segCountX2 = OSReadBigInt16(unicodeSubtable, 6);
                //UInt16 searchRange = OSReadBigInt16(unicodeSubtable, 8);
                //UInt16 entrySelector = OSReadBigInt16(unicodeSubtable, 10);
                //UInt16 rangeShift = OSReadBigInt16(unicodeSubtable, 12);
                table->cmap.format4.endCodes = (UInt16*)&unicodeSubtable[14];
                table->cmap.format4.startCodes = (UInt16*)&((UInt8*)table->cmap.format4.endCodes)[table->cmap.format4.segCountX2+2];
                table->cmap.format4.idDeltas = (UInt16*)&((UInt8*)table->cmap.format4.startCodes)[table->cmap.format4.segCountX2];
                table->cmap.format4.idRangeOffsets = (UInt16*)&((UInt8*)table->cmap.format4.idDeltas)[table->cmap.format4.segCountX2];
                //UInt16 *glyphIndexArray = &idRangeOffsets[segCountX2];
                break;
            case kFontTableFormat12:
                table->cmap.format12.nGroups = OSReadBigInt32(unicodeSubtable, 12);
                table->cmap.format12.groups = (void *)&unicodeSubtable[16];
                break;
            default:
                freeFontTable(table);
                table = NULL;
        }
    }
    CFRelease(cmapTable);
    return table;
}

// outGlyphs must be at least size n
void mapCharactersToGlyphsInFont(const fontTable *table, unichar characters[], size_t charLen, CGGlyph outGlyphs[], size_t *outGlyphLen) {
    if (table != NULL) {
        NSUInteger j = 0;
        for (NSUInteger i = 0; i < charLen; i++, j++) {
            unichar c = characters[i];
            switch (table->format) {
                case kFontTableFormat4: {
                    UInt16 segOffset;
                    BOOL foundSegment = NO;
                    for (segOffset = 0; segOffset < table->cmap.format4.segCountX2; segOffset += 2) {
                        UInt16 endCode = OSReadBigInt16(table->cmap.format4.endCodes, segOffset);
                        if (endCode >= c) {
                            foundSegment = YES;
                            break;
                        }
                    }
                    if (!foundSegment) {
                        // no segment
                        // this is an invalid font
                        outGlyphs[j] = 0;
                    } else {
                        UInt16 startCode = OSReadBigInt16(table->cmap.format4.startCodes, segOffset);
                        if (!(startCode <= c)) {
                            // the code falls in a hole between segments
                            outGlyphs[j] = 0;
                        } else {
                            UInt16 idRangeOffset = OSReadBigInt16(table->cmap.format4.idRangeOffsets, segOffset);
                            if (idRangeOffset == 0) {
                                UInt16 idDelta = OSReadBigInt16(table->cmap.format4.idDeltas, segOffset);
                                outGlyphs[j] = (c + idDelta) % 65536;
                            } else {
                                // use the glyphIndexArray
                                UInt16 glyphOffset = idRangeOffset + 2 * (c - startCode);
                                outGlyphs[j] = OSReadBigInt16(&((UInt8*)table->cmap.format4.idRangeOffsets)[segOffset], glyphOffset);
                            }
                        }
                    }
                    break;
                }
                case kFontTableFormat12: {
                    UInt32 c32 = c;
                    if (UnicharIsHighSurrogate(c)) {
                        if (i+1 < charLen) { // do we have another character after this one?
                            unichar cc = characters[i+1];
                            if (UnicharIsLowSurrogate(cc)) {
                                c32 = ConvertSurrogatePairToUTF32(c, cc);
                                i++;
                            }
                        }
                    }
                    for (UInt32 idx = 0;; idx++) {
                        if (idx >= table->cmap.format12.nGroups) {
                            outGlyphs[j] = 0;
                            break;
                        }
                        __typeof__(table->cmap.format12.groups[idx]) group = table->cmap.format12.groups[idx];
                        if (c32 >= OSSwapBigToHostInt32(group.startCharCode) && c32 <= OSSwapBigToHostInt32(group.endCharCode)) {
                            outGlyphs[j] = (CGGlyph)(OSSwapBigToHostInt32(group.startGlyphCode) + (c32 - OSSwapBigToHostInt32(group.startCharCode)));
                            break;
                        }
                    }
                    break;
                }
            }
        }
        if (outGlyphLen != NULL) *outGlyphLen = j;
    } else {
        // we have no table, so just null out the glyphs
        bzero(outGlyphs, charLen*sizeof(CGGlyph));
        if (outGlyphLen != NULL) *outGlyphLen = 0;
    }
}