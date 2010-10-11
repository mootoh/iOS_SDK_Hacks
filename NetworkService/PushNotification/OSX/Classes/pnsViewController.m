//
//  pnsViewController.m
//  pns
//
//  Created by sonson on 09/11/14.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "pnsViewController.h"
#import "GTMBase64.h"

@implementation pnsViewController

#pragma mark -
#pragma mark Alert

- (void)showAlertWithText:(NSString*)text {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:text 
												   delegate:nil 
										  cancelButtonTitle:nil 
										  otherButtonTitles:@"OK", nil];
	[alert show];
	[alert autorelease];
}

#pragma mark -
#pragma mark Instance method

- (NSString*)base64DeviceToken {
	NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
	if (![deviceToken length])
		return nil; 
	NSData *data = [NSData dataWithBytes:[deviceToken UTF8String] length:[deviceToken lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	return [GTMBase64 stringByEncodingData:data];
}

- (IBAction)regist:(id)sender {
	int row = [picker_ selectedRowInComponent:0];

	NSString *deviceTokenBase64 = [self base64DeviceToken];
	NSString *URLString = [NSString stringWithFormat:@"http://192.168.0.100/pns/regist.cgi?deviceToken=%@&action=%@&param=%d", deviceTokenBase64, @"regist", row];
	NSURL *URL = [NSURL URLWithString:URLString];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	NSURLResponse *response = nil;
	NSError *error = nil;
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

	if (error) {
		[self showAlertWithText:[error localizedDescription]];
	}
	else {
		[[NSUserDefaults standardUserDefaults] setInteger:row forKey:@"TimePicker"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[self showAlertWithText:[NSString stringWithFormat:@"Set %0d:00", row]];
	}
}

- (IBAction)unregist:(id)sender {
	NSString *deviceTokenBase64 = [self base64DeviceToken];
	NSString *URLString = [NSString stringWithFormat:@"http://192.168.0.100/pns/regist.cgi?deviceToken=%@&action=%@&param=%d", deviceTokenBase64, @"unregist", 0];
	NSURL *URL = [NSURL URLWithString:URLString];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	NSURLResponse *response = nil;
	NSError *error = nil;
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	if (error) {
		[self showAlertWithText:[error localizedDescription]];
	}
	else {
		[self showAlertWithText:[NSString stringWithFormat:@"Unregist"]];
	}
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 24;
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [NSString stringWithFormat:@"%0d:00", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}

#pragma mark -
#pragma mark dealloc
	
- (void)viewWillAppear:(BOOL)animated {
	int row = [[NSUserDefaults standardUserDefaults] integerForKey:@"TimePicker"];
	[picker_ selectRow:row inComponent:0 animated:NO];
}

- (void)dealloc {
    [super dealloc];
}

@end
