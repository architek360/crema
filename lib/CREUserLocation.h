//
//  CREUserLocation.h
//  Crema
//
//  Created by Jeff Wells on 4/29/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface CREUserLocation : NSObject
@property (nonatomic, strong) CLLocationManager *locationManager;

@end
