//
//  CREMapViewController.m
//  Crema
//
//  Created by Jeff Wells on 1/18/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface CREMapViewController ()

@end

@implementation CREMapViewController {
    GMSMapView *mapView_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadView
{
    // Create a GMSCameraPosition that tells the map to display the coordinate 33.43928, -111.95082 at zoom level 12.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:33.43928
                                                            longitude:-111.95082
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.indoorEnabled = NO;
    mapView_.delegate = self;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.compassButton = YES;
    
    self.view = mapView_;
    
    // Creates a marker in the center of the map
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(33.43928, -111.95082);
    marker.title = @"The Lofts at Rio Salado";
    marker.snippet = @"Tempe, AZ";
    marker.map = mapView_;
    NSLog(@"Done");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    NSLog(@"willMove");
    [mapView clear];
}

- (void)mapView:(GMSMapView *)mapView
idleAtCameraPosition:(GMSCameraPosition *)cameraPosition {
    NSLog(@"Camera Position now at %f,%f", cameraPosition.targetAsCoordinate.latitude,cameraPosition.targetAsCoordinate.longitude);
}

@end
