//
//  RootViewController.m
//  AccelerateTest
//
//  Created by sonson on 10/08/15.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"

#import "vdsp_dotproduct.h"
#import "blas_matrix_mult_vec.h"
#import "vdsp_int2float.h"
#import "lapack_linearEquation.h"
#import "vdsp_abs.h"

#import "TestController.h"
#import "ResultViewController.h"

@implementation RootViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	titles = [[NSMutableArray array] retain];
	
	[titles addObject:@"vdsp_dotproduct"];
	[titles addObject:@"blas_matrix_mult_vec"];
	[titles addObject:@"vdsp_int2float"];
	[titles addObject:@"lapack_linearEquation"];
	[titles addObject:@"test_abs"];
	
	[self setTitle:NSLocalizedString(@"Select test", nil)];
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
	[cell.textLabel setText:[titles objectAtIndex:indexPath.row]];

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSLog(@"%d", indexPath.row);
	
	if (indexPath.row == 0) {
		test_dotproduct();
		
		
		ResultViewController *con = [[ResultViewController alloc] initWithNibName:nil bundle:nil];
		id obj = [[TestController alloc] init];
		
		
		[self.navigationController pushViewController:con animated:YES];
		
		[con.textView setText:[obj testDotProduct]];
		[con setTitle:[titles objectAtIndex:indexPath.row]];
		[obj release];
	}
	else if (indexPath.row == 1) {
		test_matrix_mult_vec();
	}
	else if (indexPath.row == 2) {
		test_convert_int2float();
	}
	else if (indexPath.row == 3) {
		test_linearEquation();
	}
	else if (indexPath.row == 4) {
		test_abs();
	}
}

- (void)dealloc {
	[titles release];
    [super dealloc];
}

@end

