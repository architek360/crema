//
//  PFGeoBox.h
//  Crema
//
//  Created by Jeff Wells on 1/25/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>


@interface PFGeoBox : NSObject

@property (strong,nonatomic) PFGeoPoint *center;
@property (strong,nonatomic) PFGeoPoint *southwest;
@property (strong,nonatomic) PFGeoPoint *northeast;

+ (id)boxFromLocation: (CLLocationCoordinate2D)location andMapView: (MKMapView *)mapView;

+ (id)boxFromCLLocationCoordinates: (CLLocationCoordinate2D) theCenter
                         southWest: (CLLocationCoordinate2D) sw
                         northEast: (CLLocationCoordinate2D) ne;
- (id)initWithCenter:(PFGeoPoint *)center southWest: (PFGeoPoint *) sw northEast: (PFGeoPoint *) ne;

@end
