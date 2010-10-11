//
//  RootViewController.m
//  List
//
//  Created by sonson on 10/08/26.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (BOOL)addNewData:(NSString*)string {
	
	for (id aData in array) {
		if ([aData length] && [string length]) {
			if ([aData isEqualToString:string]) {
				return NO;
			}
		}
	}
	
	[array addObject:string];
	[self.tableView reloadData];
	
	return YES;
}

- (void)add:(id)sender {
	AddDataViewController *con = [[AddDataViewController alloc] initWithNibName:nil bundle:nil];
	[con autorelease];
	[con setDelegate:self];
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
	[nav autorelease];
	[self presentModalViewController:nav animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSString *str = [array objectAtIndex:indexPath.row];
	[cell.textLabel setText:str];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
		[array removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																			   target:self
																			   action:@selector(add:)];
	[addButton autorelease];
	self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	if (array == nil) {
		array = [[NSMutableArray array] retain];
		
		[array addObject:@"hoge"];
		[array addObject:@"bar"];
		[array addObject:@"bo"];
	}
}

- (void)dealloc {
	[array release];
    [super dealloc];
}

@end
