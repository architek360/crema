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

const int kLoadingCellTag = 1273;

@interface CREMapViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *annotationPins;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) BOOL mapPinsPlaced;
- (void)locationDidChange:(NSNotification *)note;

@end

@implementation CREMapViewController
@synthesize mapView;
@synthesize tableView;
@synthesize venues;
@synthesize currentPage;
@synthesize isLoading;
@synthesize mapPinsPlaced;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.venues = [[NSMutableArray alloc] init];
    currentPage = 0;
    
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
    currentPage = 0;
    
    [self fetchVenuesForMapView];
    
}

- (void)fetchVenuesForMapView {
    NSLog(@"Fetching Venues");
    [SVProgressHUD show];
//    [self showSpinnerOnLoadingCell];
    PFGeoBox *geoBox = [PFGeoBox boxFromLocation:self.mapView.centerCoordinate andMapView:self.mapView];
    
//    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    NSLog(@"Current Page: %ld", (long)currentPage);
    [CREParseAPIClient fetchVenuesInView:geoBox
                            page: currentPage
                            completion:^(NSArray *results, NSError *error) {
                                isLoading = NO;
                                if (error) {
                                    [SVProgressHUD showErrorWithStatus:@"Sorry, there was an error."];
                                } else {
                                    [SVProgressHUD dismiss];
//                                    [self.venues addObjectsFromArray:results];
//                                    self.venues = [results mutableCopy];
//                                    [self updateAnnotations];
//                                    [self.tableView reloadData];
                                    // 1. Find new posts (those that we did not already have)
                                    NSMutableArray *newVenues = [[NSMutableArray alloc] initWithCapacity:kCREVenuesPerPage];
                                    
                                    // Loop through all returned PFObjects
                                    for (CREVenue *venue in results)
                                    {
                                        // Now we check if we already had this wall post
                                        BOOL found = NO;
                                        
                                        for (CREVenue *currentVenue in self.venues)
                                        {
                                            if ([currentVenue.objectId isEqualToString:venue.objectId])                                            {
                                                found = YES;
                                            }
                                        }
                                        
                                        if (!found)
                                        {
                                            [newVenues addObject:venue];
                                            venue.animatesDrop = mapPinsPlaced;
                                        }
                                    }
                                    // 2. Find posts to remove (those we have but that we did not get from this query)
                                
                                    NSMutableArray *venuesToRemove =
                                    [[NSMutableArray alloc] initWithCapacity:kCREVenuesPerPage];
                                    
                                    if (currentPage == 0)
                                    {
                                        for (CREVenue *venue in self.venues)
                                        {
                                            BOOL found = NO;
                                            
                                            // Loop through all the wall posts we received
                                            for (CREVenue *newVenue in results)
                                            {
                                                if ([newVenue.objectId isEqualToString:venue.objectId])
                                                {
                                                    found = YES;
                                                }
                                            }
                                            
                                            // If we did not find the wall post we currently have in the set of posts
                                            // the query returned, then we add it to the 'postsToRemove' array
                                            if (!found)
                                            {
                                                [venuesToRemove addObject:venue];
                                            }
                                        }
                                    }
                                    // 3. Configure the new posts
//                                    for (PAWPost *newPost in newPosts)
//                                    {
//                                        // Animate all pins after the initial load
//                                        newPost.animatesDrop = mapPinsPlaced;
//                                    }
                                    // 4. Remove the old posts and add the new posts
                                    [self.mapView removeAnnotations:venuesToRemove];
                                    [self.venues removeObjectsInArray:venuesToRemove];
                                    
                                    // We add all new posts to both the cache and the map
                                    [self.mapView addAnnotations:newVenues];
                                    [self.venues addObjectsFromArray:newVenues];
                                    
                                    [self.tableView reloadData];
                                    
                                    self.mapPinsPlaced = YES;
                                } //end if (error) - else
                            }];
}

//- (void)updateAnnotations {
//    if (self.annotationPins) {
//        [self.mapView removeAnnotations: self.annotationPins];
//        [self.annotationPins removeAllObjects];
//    } else {
//        self.annotationPins = [[NSMutableArray alloc] initWithCapacity:[self.venues count]];
//    }
//    
//    NSLog(@"Updating Annotations");
//    for (CREVenue *venue in self.venues) {
//        CREVenueDetailedAnnotation *annotation = [[CREVenueDetailedAnnotation alloc] initWithVenue:venue];
//        [self.annotationPins push:annotation];
//        [self.mapView addAnnotation:annotation];
//    }
//}


- (MKAnnotationView *)mapView:(MKMapView *)aMapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *pinId = @"CustomPinAnnotation";
    
    if ([annotation isKindOfClass:[CREVenue class]])
    {
        MKAnnotationView *pinView =
        (MKAnnotationView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:pinId];
        
        if (!pinView)
        {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:pinId];
        }
        else
        {
            pinView.annotation = annotation;
        }
        
        pinView.image = [UIImage imageNamed:@"rocket-cup.png"];
        
//        pinView.animatesDrop = [((CREVenue *)annotation) animatesDrop];
        pinView.canShowCallout = YES;
        
        pinView.calloutOffset = CGPointMake(-1.8, 0.0);
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        pinView.rightCalloutAccessoryView = rightButton;
        
        
        return pinView;
    }
    return nil;
}

- (void) mapView:(MKMapView *)aMapView didAddAnnotationViews:(NSArray *)views {
    CGRect visibleRect = [aMapView annotationVisibleRect];

    for (MKAnnotationView *view in views) {
        if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
            return;
        }
        if ([(CREVenue *) view.annotation animatesDrop])
        {
            CGRect endFrame = view.frame;
        
            CGRect startFrame = endFrame;
            startFrame.origin.y = visibleRect.origin.y - startFrame.size.height;
            view.frame = startFrame;
        
            [UIView beginAnimations:@"drop" context:NULL];
            [UIView setAnimationDuration:0.2];
        
            view.frame = endFrame;
        
            [UIView commitAnimations];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    CREVenueDetailedAnnotation *annotation = view.annotation;
    NSInteger index = [self.venues indexOfObject:annotation];
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
}


- (void)locationDidChange:(NSNotification *)note {
    CREAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"locationDidChange: %@", appDelegate.currentLocation);
    
    [self fetchVenuesForMapView];

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
    return [self.venues count] + 1;
}

- (void) showSpinnerOnLoadingCell
{
    isLoading = YES;
    NSIndexPath *index = [NSIndexPath indexPathForRow:[self.venues count] inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}

- (UITableViewCell *)loadingCellWithSpinner
{
    
    static NSString *CellIdentifier = @"loadingCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
     UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellTag;
    cell.textLabel.text = @"";
    
    return cell;
}

- (UITableViewCell *)loadingCell
{
    
    static NSString *CellIdentifier = @"loadingCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.tag = kLoadingCellTag;
     cell.textLabel.text = @"click to load more shops";
    
    return cell;
}

- (UITableViewCell *)venueCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MapListCell";
    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	CREVenue *venue;
    
	venue = (CREVenue*) [self.venues objectAtIndex:indexPath.row];

	cell.textLabel.text = venue.name;
    [cell.detailTextLabel setText:venue.addressString];
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.venues.count) {
        return [self venueCellForIndexPath:indexPath];
    } else {
        if (isLoading) {
            return [self loadingCellWithSpinner];
        } else {
            return [self loadingCell];
        }
        
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.venues count]) {
        currentPage++;
        [self showSpinnerOnLoadingCell];
        [self fetchVenuesForMapView];
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected Row %ld", (long)indexPath.row);
    [self.mapView selectAnnotation:[self.venues
                                    objectAtIndex:indexPath.row] animated:YES];
//    [self.mapView selectAnnotation:[self.annotationPins objectAtIndex:indexPath.row] animated:YES];
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
    [self.locationManager stopUpdatingLocation];
    currentPage = 0;
	self.mapPinsPlaced = NO;
}



@end
