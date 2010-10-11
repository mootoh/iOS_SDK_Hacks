//
//  RootViewController.m
//  UIAutomationTest
//
//  Created by sonson on 10/08/21.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "TableViewTestController.h"

@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setTitle:@"UI Auto"];

	if (titles == nil) {
		titles = [[NSMutableArray array] retain];
		[titles addObject:@"AlertView"];
		[titles addObject:@"TableViewTestController"];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [titles count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	[cell.textLabel setText:[titles objectAtIndex:indexPath.row]];

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.row == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test"
														message:@"This is test"
													   delegate:nil
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:@"OK", nil];
		[alert show];
		[alert release];
	}
	else if (indexPath.row == 1) {
		TableViewTestController *con = [[TableViewTestController alloc] initWithNibName:nil bundle:nil];
		[self.navigationController pushViewController:con animated:YES];
		[con release];
	}
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[titles release];
    [super dealloc];
}

@end

