//
//  AddDataViewController.m
//  List
//
//  Created by sonson on 10/08/26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddDataViewController.h"


@implementation AddDataViewController

@synthesize delegate;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																				target:self
																				action:@selector(save:)];
	[saveButton autorelease];
	self.navigationItem.rightBarButtonItem = saveButton;
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				target:self
																				action:@selector(cancel:)];
	[cancelButton autorelease];
	self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)save:(id)sender {
	if ([inputField.text length] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"Please input "
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:@"OK", nil];
		[alert show];
		[alert release];
	}
	else if ([delegate addNewData:[NSString stringWithString:inputField.text]]) {
		// OK
		[self dismissModalViewControllerAnimated:YES];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"This data has already been saved."
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:@"OK", nil];
		[alert show];
		[alert release];
	}
}

- (void)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [super dealloc];
}

@end
