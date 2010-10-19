//
//  MyTableViewCell.h
//  UITableViewHacks
//
//  Created by sonson on 10/03/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyCellContentView;
@class Content;

@interface MyTableViewCell : UITableViewCell {
	MyCellContentView	*myContentView;
	Content				*content;
}
@property (nonatomic, retain) Content *content;
@end
