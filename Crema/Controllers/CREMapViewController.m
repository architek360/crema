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
#import "CREVenueDetailViewController.h"
#import "PFGeoBox.h"

@interface CREMapViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *annotationPins;
- (void)locationDidChange:(NSNotification *)note;

@end

@implementation CREMapViewController
@synthesize mapView;
@synthesize tableView;
@synthesize venues;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regionDidChangeAnimated: %f, %f", aMapView.centerCoordinate.latitude, aMapView.centerCoordinate.longitude);
//    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:aMapView.centerCoordinate.latitude longitude:aMapView.centerCoordinate.longitude];
    
    [self fetchVenuesForMapView];
    
}

- (void)fetchVenuesForMapView {
    NSLog(@"Fetching Venues");
    [SVProgressHUD show];
    PFGeoBox *geoBox = [PFGeoBox boxFromLocation:self.mapView.centerCoordinate andMapView:self.mapView];
    
//    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    [CREParseAPIClient fetchVenuesInView:geoBox
                            page: 1
                            completion:^(NSArray *results, NSError *error) {
                                if (error) {
                                    [SVProgressHUD showErrorWithStatus:@"Sorry, there was an error."];
                                } else {
                                    [SVProgressHUD dismiss];
                                    self.venues = [results mutableCopy];
                                    [self updateAnnotations];
                                    [self.tableView reloadData];
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
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *pinId = @"CustomPinAnnotation";
    
    if ([annotation isKindOfClass:[CREVenueDetailedAnnotation class]])
    {
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:pinId];
        
        if (!pinView)
        {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:pinId];
        }
        else
        {
            pinView.annotation = annotation;
        }
        
//        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"rocket-cup.png"];
        pinView.calloutOffset = CGPointMake(-1.8, 0.0);
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        pinView.rightCalloutAccessoryView = rightButton;
        
        
        return pinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    CREVenueDetailedAnnotation *annotation = view.annotation;
    NSInteger index = [self.annotationPins indexOfObject:annotation];
    NSLog(@"Count: %ld, Index: %ld", (unsigned long)[self.annotationPins count], (long)index);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
                      calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"venueDetailModal" sender:self];
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
    
    [self fetchVenuesForMapView];
//    [self fetchVenuesForLocation:appDelegate.currentLocation];

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Update Locations");
    CLLocation *location = [locations lastObject];
    [self zoomToLocation:location radius:1000];
    CREAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate setCurrentLocation:location];
}

#pragma mark - Segue view
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return [sender isEqual:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"venueDetailModal"])
    {
        NSIndexPath *indexPath;
        NSLog(@"Sender: %@", sender);
        indexPath = self.tableView.indexPathForSelectedRow;
        
        CREVenueDetailViewController *destinationController = [segue destinationViewController];
        CREVenue *venue = self.venues[indexPath.row];
        destinationController.venue = venue;
        destinationController.index = indexPath;
    }
}

- (IBAction)unwindToMainView:(UIStoryboardSegue *)segue
{
    //Will need unwind for reloading upvotes
    CREVenueDetailViewController *source = [segue sourceViewController];
    CREVenue *venue = source.venue;
    [self.venues replaceObjectAtIndex:source.index.row withObject:venue];
    [self.tableView reloadRowsAtIndexPaths:@[source.index] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.venues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"MapListCell";
    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	CREVenue *venue;
    
	venue = (CREVenue*) [self.venues objectAtIndex:indexPath.row];
    NSLog(@"Venue: %@", venue.name);
	cell.textLabel.text = venue.name;
    NSLog(@"cell label: %@", cell.textLabel.text);
    [cell.detailTextLabel setText:venue.addressString];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected Row %ld", (long)indexPath.row);
    [self.mapView selectAnnotation:[self.annotationPins objectAtIndex:indexPath.row] animated:YES];
//    return nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self performSegueWithIdentifier:@"venueDetailModal" sender:self];
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
