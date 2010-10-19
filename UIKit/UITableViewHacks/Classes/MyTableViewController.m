//
//  MyTableViewController.m
//  UITableViewHacks
//
//  Created by sonson on 10/03/13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyTableViewController.h"
#import "Content.h"
#import "MyTableViewCell.h"
#import "MyCellContentView.h"

@implementation MyTableViewController

- (void)toggleFrameDrawing:(id)sender {
	UISegmentedControl *control = sender;
	if ([control selectedSegmentIndex] == 0) {
		[MyCellContentView setDrawDebugFrame:NO];
		[self.tableView reloadData];
	}
	else if ([control selectedSegmentIndex] == 1) {
		[MyCellContentView setDrawDebugFrame:YES];
		[self.tableView reloadData];
	}
}

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		contents = [[NSMutableArray array] retain];
		for (int i = 0; i < 100; i++) {
			Content *content = [[Content alloc] initWithNumber:i];
			[contents addObject:content];
		}
		
		NSArray *titles = [NSArray arrayWithObjects:@"None", @"Frame", nil];
		UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:titles];
		[control setSegmentedControlStyle:UISegmentedControlStyleBar];
		//	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:control];
		[control addTarget:self action:@selector(toggleFrameDrawing:) forControlEvents:UIControlEventValueChanged];
		self.navigationItem.titleView = control;
		[control setSelectedSegmentIndex:[MyCellContentView drawDebugFrame]];
		
		self.navigationItem.leftBarButtonItem = self.editButtonItem;
		
	}
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [contents count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.row == 2);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    MyTableViewCell *cell = (MyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	[cell setContent:[contents objectAtIndex:indexPath.row]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc {
    [super dealloc];
}


@end

