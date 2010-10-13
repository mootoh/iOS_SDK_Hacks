    //
//  CameraViewController.m
//  CameraPixel
//
//  Created by sonson on 10/06/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import "CCEAGLView.h"

@implementation CameraViewController

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		[self.view setBackgroundColor:[UIColor grayColor]];
	}	
    return self;
}

- (void)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)setupGLView {
	glview = [[CCEAGLView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:glview];
	[glview startAnimation];
	[glview release];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self setupGLView];
	[indicator removeFromSuperview];
	indicator = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	self.navigationItem.rightBarButtonItem = cancelButton;
	[cancelButton release];
	
	if (indicator == nil) {
		indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
		[self.view addSubview:indicator];
		CGRect indicatorRect = indicator.frame;
		indicatorRect.origin.x = (int)(self.view.bounds.size.width - indicatorRect.size.width)/2;
		indicatorRect.origin.y = (int)(self.view.bounds.size.height - indicatorRect.size.height)/2;
		indicator.frame = indicatorRect;
		[indicator startAnimating];
	}
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	DNSLogMethod
	[glview stopAnimation];
    [super dealloc];
}


@end
