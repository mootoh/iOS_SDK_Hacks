//
//  ExternalViewController.m
//  VGAOutput
//
//  Created by sonson on 10/09/14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ExternalViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation ExternalViewController

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"------");

	MKCoordinateRegion region = {35.658517, 139.701334, 0.01, 0.01};
	[mapview setRegion:region];
	
	UIView *test = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-50, 100, 100)];
	[test setBackgroundColor:[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5]];
	[self.view addSubview:test];
	[test release];
	
	// アニメーションを作成する
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation.duration = 1.0f;
	animation.autoreverses = YES;
	animation.repeatCount = 40;
	animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0.0f, 1)];
	
	// レイヤーにアニメーションを追加する
	[test.layer addAnimation:animation forKey:@"positionAnimation"];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
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
    [super dealloc];
}


@end
