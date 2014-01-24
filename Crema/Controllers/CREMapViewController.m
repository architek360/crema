//
//  CREMapViewController.m
//  Crema
//
//  Created by Jeff Wells on 1/18/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//
#import "CREAppDelegate.h"
#import "CREMapViewController.h"
#import "CREParseAPIClient.h"
#import "SVProgressHUD.h"
#import "CREVenueAnnotation.h"

@interface CREMapViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *venues;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

@end

@implementation CREMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateLocation];
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    CREAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // This is where the post happens
    [appDelegate setCurrentLocation:newLocation];
}


- (void)updateLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)zoomToLocation:(CLLocation *)location radius:(CGFloat)radius {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, radius * 2, radius * 2);
    [self.mapView setRegion:region animated:YES];
}

- (void)fetchVenuesForLocation:(CLLocation *)location {
    [SVProgressHUD show];
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    [CREParseAPIClient fetchVenuesNear:point
                            completion:^(NSArray *venues, NSError *error) {
                                if (error) {
                                    [SVProgressHUD showErrorWithStatus:@"Sorry, there was an error."];
                                } else {
                                    [SVProgressHUD dismiss];
                                    self.venues = venues;
                                    [self updateAnnotations];
                                }
                            }];
}

- (void)updateAnnotations {
    for (CREVenue *venue in self.venues) {
        CREVenueAnnotation *annotation = [[CREVenueAnnotation alloc] initWithVenue:venue];
        [self.mapView addAnnotation:annotation];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.locationManager = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kCRELocationChangeNotification
                                                  object:nil];
}


#pragma mark - CLLocationManagerDelegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    static BOOL locationUpdated = NO;
    if (!locationUpdated) {
        locationUpdated = YES;
        CLLocation *location = [locations lastObject];
        [self fetchVenuesForLocation:location];
        [self zoomToLocation:location radius:2000];
        [self.locationManager stopUpdatingLocation];
    }
}

@end
