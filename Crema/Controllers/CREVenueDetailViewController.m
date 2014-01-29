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
        self.upVoted = NO;
        [self.upvotesLabel setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName,nil] forState:UIControlStateNormal];
    } else {
        self.venue.upvotes = @(self.venue.upvotes.intValue + 1);
        self.upVoted = YES;
        [self.upvotesLabel setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16], NSFontAttributeName,nil] forState:UIControlStateNormal];
    }
    self.upvotesLabel.title = [self labelForUpvotes:self.venue.upvotes];
    [self.venue saveInBackground];
}

- (NSString *) labelForUpvotes: (NSNumber *) votes {
    return [NSString stringWithFormat:@"%i votes", self.venue.upvotes.integerValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
