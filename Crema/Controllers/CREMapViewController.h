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
#import "CREParseAPIClient.h"
#import "SVProgressHUD.h"
#import "ObjectiveSugar.h"
#import "CREVenueDetailViewController.h"
#import "PFGeoBox.h"
#import "UIImageView+AFNetworking.h"
#import "CRELoginViewController.h"
#import "CREVenueCollection.h"
#import "CREVenueAnnotation.h"
#import "CREAppDelegate.h"

@interface CREMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;



@end
