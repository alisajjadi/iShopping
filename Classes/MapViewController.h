//
//  MapViewController.h
//  iShopping
//
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapViewController : UIViewController <MKMapViewDelegate , MKReverseGeocoderDelegate> {

	IBOutlet MKMapView	*mapView;
	
	MKReverseGeocoder	*reverseGeocoder;
}

- (IBAction) done;

@end
