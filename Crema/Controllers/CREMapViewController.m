//
//  CREMapViewController.m
//  Crema
//
//  Created by Jeff Wells on 1/18/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREMapViewController.h"


@interface CREMapViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *annotationPins;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) BOOL mapPinsPlaced;

@end

@implementation CREMapViewController
@synthesize mapView;
@synthesize currentPage;
@synthesize mapPinsPlaced;

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentPage = 0;
    
    [self.locationManager startUpdatingLocation];
}

- (void)zoomToLocation:(CLLocation *)location radius:(CGFloat)radius {
    NSLog(@"Zooming");
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, radius * 2, radius * 2);
    [self.mapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regionLocation: %@", [[self locationManager] location]);
    NSLog(@"regionDidChangeAnimated: %f, %f, %d", aMapView.centerCoordinate.latitude, aMapView.centerCoordinate.longitude, animated);
    
    if([[self locationManager] location] != nil)
    {
        currentPage = 0;
        [self fetchVenuesInMapView];
    }
}

- (void)fetchVenuesInMapView {
    NSLog(@"Fetching Venues");
    [SVProgressHUD show];
    PFGeoBox *geoBox = [PFGeoBox boxFromLocation:self.mapView.centerCoordinate andMapView:self.mapView];

    [CREParseAPIClient fetchVenuesInView:geoBox
                            page: currentPage
                            completion:^(NSArray *results, NSError *error) {
                                if (error) {
                                    [SVProgressHUD showErrorWithStatus:@"Sorry, there was an error."];
                                } else {
                                    [SVProgressHUD dismiss];
                                    // 1. Find new posts (those that we did not already have)
                                    NSMutableArray *newVenues = [[NSMutableArray alloc] initWithCapacity:kCREVenuesPerPage];
                                    
                                    // Loop through all returned PFObjects
                                    for (CREVenue *venue in results)
                                    {
                                        // Now we check if we already had this wall post
                                        BOOL found = NO;
                                        
                                        for (CREVenue *currentVenue in [CREVenueCollection venues])
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
                                        for (CREVenue *venue in [CREVenueCollection venues])
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
                                    // 3. Remove the old posts and add the new posts
                                    [self.mapView removeAnnotations:venuesToRemove];
                                    [[CREVenueCollection venues] removeObjectsInArray:venuesToRemove];
                                    
                                    // We add all new posts to both the cache and the map
                                    [self.mapView addAnnotations:newVenues];
                                    [[CREVenueCollection venues] addObjectsFromArray:newVenues];
                                    
                                    self.mapPinsPlaced = YES;
                                } //end if (error) - else
                            }];
}


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
        
        pinView.image = [UIImage imageNamed:@"star.png"];
        
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
    CREVenue *annotation = (CREVenue *) view.annotation;
    NSInteger index = [[CREVenueCollection venues] indexOfObject:annotation];
    NSLog(@"Count: %ld, Index: %ld", (unsigned long)[self.annotationPins count], (long)index);
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
//    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
                      calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"venueDetailModal" sender:view];
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
//    Do we want to research at current location if moved? maybe better if there is a 'find me' button


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Update Locations");
    CLLocation *location = [locations lastObject];
    [self zoomToLocation:location radius:1000];
}

#pragma mark - Segue view

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"venueDetailModal"])
    {
        MKAnnotationView *view = sender;
        CREVenue *venue = (CREVenue *) view.annotation;
        
        CREVenueDetailViewController *destinationController = [segue destinationViewController];

        destinationController.venue = venue;
    }
}

- (IBAction)unwindToMainView:(UIStoryboardSegue *)segue
{
    //Will need unwind for reloading upvotes
    CREVenueDetailViewController *source = [segue sourceViewController];
    CREVenue *venue = source.venue;
    [[CREVenueCollection venues] replaceObjectAtIndex:source.index.row withObject:venue];
    //    [self.tableView reloadRowsAtIndexPaths:@[source.index] withRowAnimation:UITableViewRowAnimationNone];
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
