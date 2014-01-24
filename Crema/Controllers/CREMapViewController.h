//
//  CREMapViewController.h
//  Crema
//
//  Created by Jeff Wells on 1/18/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CREVenue.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface CREMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
