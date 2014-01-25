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
#import "CREVenueDetailedAnnotation.h"
#import "ObjectiveSugar.h"
#import "CREListViewController.h"

@interface CREMapViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *venues;
@property (nonatomic, strong) NSMutableArray *annotationPins;
- (void)locationDidChange:(NSNotification *)note;
@property (nonatomic, strong) CREListViewController *listViewController;

@end

@implementation CREMapViewController
@synthesize listViewController;
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.listViewController = [[CREListViewController alloc] initWithStyle:UITableViewStylePlain];
	[self addChildViewController:self.listViewController];
    
    self.listViewController.view.frame = CGRectMake(0.0f, self.mapView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.mapView.bounds.size.height);
	[self.view addSubview:self.listViewController.view];
    [SVProgressHUD setOffsetFromCenter: UIOffsetMake(0.0f, -self.mapView.bounds.size.height/2.0)];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationDidChange:)
                                                 name:kCRELocationChangeNotification
                                               object:nil];
    
    [self startLocationUpdates];
}

- (void)zoomToLocation:(CLLocation *)location radius:(CGFloat)radius {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, radius * 2, radius * 2);
    [self.mapView setRegion:region animated:YES];
}

- (void)fetchVenuesForLocation:(CLLocation *)location {
    NSLog(@"Fetching Venues");
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
    if (self.annotationPins) {
        [self.mapView removeAnnotations: self.annotationPins];
        [self.annotationPins removeAllObjects];
    } else {
        self.annotationPins = [[NSMutableArray alloc] initWithCapacity:[self.venues count]];
    }
    
    NSLog(@"Updating Annotations");
    for (CREVenue *venue in self.venues) {
        CREVenueDetailedAnnotation *annotation = [[CREVenueDetailedAnnotation alloc] initWithVenue:venue];
        [self.annotationPins push:annotation];
        [self.mapView addAnnotation:annotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    // We will let the system handle the user location annotation (the blue dot)
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *pinId = @"CustomPinAnnotation";
    
    // Handle any other annotations
    if ([annotation isKindOfClass:[CREVenueDetailedAnnotation class]])
    {
        // Try to dequeue an existing pin view first
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:pinId];
        
        // If an existing pin view was not available, create one
        if (!pinView)
        {
            // Create a new annotation view (Note MKPinAnnotationView is a
            // subclass of MKAnnotationView)
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:pinId];
        }
        else // If one did exist, then set the parameter MKAnnotation to the new pinView
        {
            pinView.annotation = annotation;
        }
        
        // Set the characteristics of the annotation view
//        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"rocket-cup.png"];
        pinView.calloutOffset = CGPointMake(-1.8, 0.0);
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        pinView.rightCalloutAccessoryView = rightButton;
        
        
        return pinView;
    }
    // Return nil for any other (undefined) MKAnnotation
    return nil;
}


#pragma mark - CLLocationManagerDelegate methods
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    }
    return _locationManager;
}

- (void) startLocationUpdates {
    [self.locationManager startUpdatingLocation];
//    CLLocation *currentLocation = self.locationManager.location;
//    if (currentLocation) {
//        CREAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//        appDelegate.currentLocation = currentLocation;
//    }
    
}


- (void)locationDidChange:(NSNotification *)note {
    CREAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"locationDidChange: %@", appDelegate.currentLocation);
    
    [self fetchVenuesForLocation:appDelegate.currentLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Update Locations");
    CLLocation *location = [locations lastObject];
    [self zoomToLocation:location radius:1000];
    CREAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate setCurrentLocation:location];
}
#pragma mark - CREMapViewController memory management methods

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



@end
