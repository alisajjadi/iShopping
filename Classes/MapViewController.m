//
//  MapViewController.m
//  iShopping
//
//  Created by Ali Sajjadi on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController


#pragma mark
#pragma mark Location

-(IBAction) done
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)updateUserLocation
{
	MKUserLocation	*userLocation = mapView.userLocation;
	CLLocationCoordinate2D	coordinate = userLocation.location.coordinate;

	[mapView setCenterCoordinate:coordinate animated:YES];
	
	if (!reverseGeocoder)
	{
		reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
		reverseGeocoder.delegate = self;
		[reverseGeocoder start];
	}
}

#pragma mark
#pragma mark MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	mapView.userLocation.title = placemark.title;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	
	NSLog (@"Reverse Geo Coder Error:%@",error);
	/* 
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error:" message:@"Cannot Find User's Location!" 
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
*/
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    for(MKAnnotationView *annotationView in views) {
        if(annotationView.annotation == mv.userLocation) {
            MKCoordinateRegion region;
            MKCoordinateSpan span;
			
            span.latitudeDelta=0.05;
            span.longitudeDelta=0.05; 
			
            CLLocationCoordinate2D location=mv.userLocation.coordinate;
			
            region.span=span;
            region.center=location;
			
            [mv setRegion:region animated:TRUE];
            [mv regionThatFits:region];
        }
    }
}

#pragma mark -

- (void) viewDidLoad
{
	[self updateUserLocation];
	[super viewDidLoad];
}

- (void)dealloc
{
	[mapView release];
	[reverseGeocoder release];
	
	[super dealloc];
}

@end
