//
//  PFGeoBox.m
//  Crema
//
//  Created by Jeff Wells on 1/25/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "PFGeoBox.h"

@implementation PFGeoBox


+ (id) boxFromLocation: (CLLocationCoordinate2D) location
            andMapView: (MKMapView *) mapView {
    
    CGPoint nePoint = CGPointMake(mapView.bounds.origin.x + mapView.bounds.size.width, mapView.bounds.origin.y);
    CGPoint swPoint = CGPointMake((mapView.bounds.origin.x), (mapView.bounds.origin.y + mapView.bounds.size.height));
    
    CLLocationCoordinate2D neCoord = [mapView convertPoint:nePoint toCoordinateFromView:mapView];
    CLLocationCoordinate2D swCoord = [mapView convertPoint:swPoint toCoordinateFromView:mapView];
    
    return [self boxFromCLLocationCoordinates:location southWest:swCoord northEast:neCoord];
}


+ (id)boxFromCLLocationCoordinates: (CLLocationCoordinate2D) theCenter
                         southWest: (CLLocationCoordinate2D) sw
                         northEast: (CLLocationCoordinate2D) ne
{
 
    PFGeoPoint *centerPoint = [PFGeoPoint geoPointWithLatitude:theCenter.latitude longitude:theCenter.longitude];
    PFGeoPoint *swPoint = [PFGeoPoint geoPointWithLatitude:sw.latitude longitude:sw.longitude];
    PFGeoPoint *nePoint = [PFGeoPoint geoPointWithLatitude:ne.latitude longitude:ne.longitude];
    
    return [[self alloc] initWithCenter:centerPoint southWest:swPoint northEast:nePoint];
}

- (id)initWithCenter:(PFGeoPoint *)theCenter
           southWest: (PFGeoPoint *) sw
           northEast: (PFGeoPoint *) ne
{
    self = [super init];
    if (self) {
        self.center = theCenter;
        self.southwest = sw;
        self.northeast = ne;
    }
    return self;
}



@end
