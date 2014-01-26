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

@interface CREMapViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *annotationPins;
- (void)locationDidChange:(NSNotification *)note;
//- (IBAction)addButtonSelected:(id)sender;

@end

@implementation CREMapViewController
@synthesize mapView;
@synthesize tableView;
@synthesize venues;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SVProgressHUD setOffsetFromCenter: UIOffsetMake(0.0f, -self.mapView.bounds.size.height/2.0)];
    
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
//											  initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonSelected:)];
//	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
//											 initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonSelected:)];
//	self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Anywall.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationDidChange:)
                                                 name:kCRELocationChangeNotification
                                               object:nil];
    
    [self startLocationUpdates];
}
//- (IBAction)addButtonSelected:(id)sender {
//    
//}

- (void)zoomToLocation:(CLLocation *)location radius:(CGFloat)radius {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, radius * 2, radius * 2);
    [self.mapView setRegion:region animated:YES];
}

- (void)fetchVenuesForLocation:(CLLocation *)location {
    NSLog(@"Fetching Venues");
    [SVProgressHUD show];
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    [CREParseAPIClient fetchVenuesNear:point
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

#pragma mark - Segue view

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"venueDetailModal"])
    {
        NSIndexPath *indexPath;
        
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
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSLog(@"Venue: %@", venue.name);
	cell.textLabel.text = venue.name;
    NSLog(@"cell label: %@", cell.textLabel.text);
    [cell.detailTextLabel setText:venue.addressString];
    
    return cell;

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
