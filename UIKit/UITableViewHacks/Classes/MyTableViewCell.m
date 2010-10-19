//
//  MyTableViewCell.m
//  UITableViewHacks
//
//  Created by sonson on 10/03/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyTableViewCell.h"
#import "MyCellContentView.h"

@implementation MyTableViewCell

@synthesize content;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		myContentView = [[MyCellContentView alloc] initWithFrame:self.contentView.frame withCell:self];
        myContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        myContentView.contentMode = UIViewContentModeLeft;
		[self.contentView addSubview:myContentView];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	myContentView.highlighted = highlighted;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
	myContentView.backgroundColor = backgroundColor;
}

- (void)dealloc {
	[content release];
	[myContentView release];
    [super dealloc];
}

@end
