//
//  MapHacksViewController.h
//  MapHacks
//
//  Created by sonson on 09/08/30.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapHacksViewController : UIViewController {
	IBOutlet MKMapView *mapView_;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@end

