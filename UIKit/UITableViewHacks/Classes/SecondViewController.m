//
//  SecondViewController.m
//  UITableViewHacks
//
//  Created by sonson on 10/03/13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

+ (UINavigationController*)navigationController {
	SecondViewController *viewCon = [[SecondViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:viewCon];
	[viewCon release];
	return [navi autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	UIBarButtonItem *toggle = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStyleBordered target:self action:@selector(toggle:)];
	self.navigationItem.rightBarButtonItem = [toggle autorelease];
}

- (void)toggle:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [super dealloc];
}

@end
