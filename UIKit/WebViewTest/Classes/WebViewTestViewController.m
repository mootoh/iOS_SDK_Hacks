//
//  WebViewTestViewController.m
//  WebViewTest
//
//  Created by sonson on 09/11/24.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "WebViewTestViewController.h"

#import "UICWebView.h"
#import "UICWebView+HookTouch.h"

@implementation WebViewTestViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	UIWebView *webview = [[[UIWebView alloc] initWithFrame:self.view.frame] autorelease];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
	NSData *data = [NSData dataWithContentsOfFile:path];
	
	[webview loadHTMLString:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] baseURL:nil];
	
	[self.view addSubview:webview];
	[webview setDelegate:self];
    [super viewDidLoad];
}

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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
