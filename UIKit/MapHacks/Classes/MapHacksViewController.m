//
//  MapHacksViewController.m
//  MapHacks
//
//  Created by sonson on 09/08/30.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MapHacksViewController.h"
#import "JSON.h"

#import "MyAnnotation.h"

@implementation MapHacksViewController

@synthesize mapView = mapView_;

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
	
	MKPinAnnotationView *annotationView = nil;
	
	annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Annotationview"];
	if (annotationView == nil) {
		annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotationview"];
		[annotationView autorelease];
	}
	
	annotationView.canShowCallout = YES;
	annotationView.animatesDrop = YES;
	return annotationView;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {	
	// Google API
	NSString *apiKey = @"ABQIAAAAyt0rtmRh90pLhA10hrJISxTwDowqL9HHKg3JSnSF0sTQmVxJ4RTqGCmKrrG7q5_r6O2v9epSc5QSTA";
	NSString *googleAPIQuery = @"http://ajax.googleapis.com/ajax/services/search/local?q=%@&v=1.0&key=%@&hl=ja&sll=%.4f,%.4f&sspn=%.6f,%.6f";
	
	// 現在MKMapViewが表示している領域の情報を取得
	MKCoordinateRegion region = self.mapView.region;
	
	// 検索キーワードをエスケープ
	NSString *percentEscaped = [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *url = [NSString stringWithFormat:googleAPIQuery, percentEscaped, apiKey, region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta];
	
	// リクエスト
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	// 結果得られるJSONデータをJSON.frameworkでパース
	NSString *resultJSONString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
	id parsed = [resultJSONString JSONValue];
	
	// JSONデータを取得
	// http://code.google.com/intl/ja/apis/ajaxsearch/documentation/reference.html#_intro_fonje
	NSDictionary *responseData = [parsed objectForKey:@"responseData"];
	NSArray *results = [responseData objectForKey:@"results"];
	
	if ([results count]) {
		// 現在のアノテーションを除去
		[self.mapView removeAnnotations:self.mapView.annotations];
		NSMutableArray *annotations = [NSMutableArray array];
		for (NSDictionary *result in results) {
			CLLocationCoordinate2D coord;
			NSString *title = [result objectForKey:@"titleNoFormatting"];
			coord.latitude = [[result objectForKey:@"lat"] floatValue];
			coord.longitude = [[result objectForKey:@"lng"] floatValue];
			MyAnnotation *annotation = [[[MyAnnotation alloc] init] autorelease];
			annotation.title = title;
			annotation.coordinate = coord;
			[annotations addObject:annotation];
		}
		// 現在のアノテーションを追加
		[self.mapView addAnnotations:annotations];
	}
	
	// キーワードを隠す
	[searchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.mapView.showsUserLocation = YES;
}

- (void)dealloc {
	[mapView_ release];
    [super dealloc];
}

@end
