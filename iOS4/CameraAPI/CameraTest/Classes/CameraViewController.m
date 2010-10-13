//
//  CameraViewController.m
//  CameraTest
//
//  Created by sonson on 10/06/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraController.h"

@implementation CameraViewController

+ (UINavigationController*)navigationController {
	CameraViewController *con = [[CameraViewController alloc] initWithNibName:nil bundle:nil];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
	[con release];
	return [nav autorelease];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
	if (self = [super initWithNibName:nibName bundle:nibBundle]) {
		camera = [[CameraController alloc] initWithSessionPreset:AVCaptureSessionPreset640x480];
		previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:[camera session]];
		previewLayer.frame = CGRectMake(0, -20, self.view.bounds.size.width, self.view.bounds.size.height);
		[self.view.layer addSublayer:previewLayer];
		[camera start];
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	UIBarButtonItem *closeButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
	self.navigationItem.rightBarButtonItem = closeButton;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[previewLayer removeFromSuperlayer];
}

- (void)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[camera release];
	[super dealloc];
}

@end
