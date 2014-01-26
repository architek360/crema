//
//  CREVenueDetailViewController.m
//  Crema
//
//  Created by Jeff Wells on 1/25/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREVenueDetailViewController.h"

@interface CREVenueDetailViewController ()

@end

@implementation CREVenueDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", @"https://foursquare.com/v/", self.venue.venueId];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
