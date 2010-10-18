//
//  MyAnnotation.h
//  MapHacks
//
//  Created by sonson on 09/08/31.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>  {
	NSString *title;
	NSString *subtitle;
	CLLocationCoordinate2D coordinate;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@end