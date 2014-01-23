//
//  CREReviewNewViewController.m
//  Crema
//
//  Created by Jeff Wells on 1/23/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREReviewNewViewController.h"
#import "CREVenueAnnotation.h"
#import "ObjectiveSugar.h"

@interface CREReviewNewViewController ()

@end

@implementation CREReviewNewViewController
@synthesize nameLabel;
@synthesize addressLabel;
@synthesize cityLabel;
@synthesize venue;


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
    
    nameLabel.text = self.venue.name;
    NSArray* address = [self.venue.addressString split:@", "];
    addressLabel.text = address[0];
    cityLabel.text = [address[@"1..2"] componentsJoinedByString:@", "];
    if (address[3]) {
        cityLabel.text = [@[cityLabel.text, address[3]] componentsJoinedByString:@" "];
    }
    
    
    [self updateMap];
    
}

- (void)updateMap {
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.venue.latitude.doubleValue, self.venue.longitude.doubleValue);
    [self zoomToCoordinates:location radius:500];
    
    CREVenueAnnotation *annotation = [[CREVenueAnnotation alloc] initWithVenue:self.venue];
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
}

- (void)zoomToCoordinates:(CLLocationCoordinate2D)coordinates radius:(CGFloat)radius {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinates, radius * 2, radius * 2);
    [self.mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
