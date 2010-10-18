//
//  RootViewController.m
//  UITableViewHacks
//
//  Created by sonson on 10/03/11.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "SecondViewController.h"

@implementation RootViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	UIBarButtonItem *toggle = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStyleBordered target:self action:@selector(toggle:)];
	self.navigationItem.rightBarButtonItem = [toggle autorelease];
}

- (void)toggle:(id)sender {
	UINavigationController *nav = [SecondViewController navigationController];
	nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:nav animated:YES];
}

@end

