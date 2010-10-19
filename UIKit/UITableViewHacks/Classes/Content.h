//
//  Content.h
//  UITableViewHacks
//
//  Created by sonson on 10/03/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Content : NSObject {
	NSString	*title;
	UIImage		*icon;
}
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) UIImage *icon;
- (id) initWithNumber:(int)num;
@end
