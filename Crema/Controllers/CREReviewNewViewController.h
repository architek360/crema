//
//  CREReviewNewViewController.h
//  Crema
//
//  Created by Jeff Wells on 1/23/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CREVenue.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "CREVenueAnnotation.h"
#import "ObjectiveSugar.h"
#import "SVProgressHUD.h"


@interface CREReviewNewViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic) CREVenue *venue;
@property (nonatomic) NSIndexPath *index;
@end
