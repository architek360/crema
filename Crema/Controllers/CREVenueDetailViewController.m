//
//  CREVenueDetailViewController.m
//  Crema
//
//  Created by Jeff Wells on 1/25/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREVenueDetailViewController.h"

@interface CREVenueDetailViewController ()
@property (nonatomic) BOOL upVoted;
@end

@implementation CREVenueDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", @"https://foursquare.com/v/", self.venue.venueId];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    self.upvotesLabel.title = [self labelForUpvotes:self.venue.upvotes];
    
    [self.webView loadRequest:requestObj];
}

- (IBAction)tapVoteCount:(id)sender {
    if (self.upVoted) {
        self.venue.upvotes = @(self.venue.upvotes.intValue - 1);
//        [buttonItem setTitleTextAttributes:@{
//                                             UITextAttributeFont: [UIFont fontWithName:@"Helvetica-Bold" size:26.0],
//                                             UITextAttributeTextColor: [UIColor greenColor]
//                                             } forState:UIControlStateNormal];
    } else {
        self.venue.upvotes = @(self.venue.upvotes.intValue + 1);
    }
    self.upvotesLabel.title = [self labelForUpvotes:self.venue.upvotes];
}

- (NSString *) labelForUpvotes: (NSNumber *) votes {
    return [NSString stringWithFormat:@"%i votes", self.venue.upvotes.integerValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapVoteCount:(id)sender {
}
@end
