//
//  respondToSelectorViewController.m
//  respondToSelector
//
//  Created by sonson on 09/04/08.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "respondToSelectorViewController.h"
#import "UIWebView+respondToSelector.h"

@implementation respondToSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com"]];
	[webView loadRequest:req];
}

- (void)dealloc {
    [super dealloc];
}

@end
