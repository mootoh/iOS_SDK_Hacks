//
//  MyCellContentView.h
//  UITableViewHacks
//
//  Created by sonson on 10/03/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTableViewCell;

@interface MyCellContentView : UIView {
    BOOL				highlighted;
	MyTableViewCell		*cell;
}
@property (nonatomic, assign) BOOL highlighted;
+ (void)setDrawDebugFrame:(BOOL)newValue;
+ (BOOL)drawDebugFrame;
- (id)initWithFrame:(CGRect)frame withCell:(MyTableViewCell*)newcell;
@end
