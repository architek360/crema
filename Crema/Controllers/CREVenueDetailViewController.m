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
    [self.webView loadRequest:requestObj];
    self.upvotesLabel.title = [self labelForUpvotes:self.venue.upvote_count];
    
    
    if([PFUser currentUser])
    {
        NSLog(@"get Like");
        self.upVoted = [CREParseAPIClient currentUserLikesVenue:self.venue];
        if (self.upVoted) {
            [self.upvotesLabel setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16], NSFontAttributeName,nil] forState:UIControlStateNormal];
        } else {
            [self.upvotesLabel setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName,nil] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)tapVoteCount:(id)sender {
    if (![PFUser currentUser]) return;
    //segue to login?
    
    if (self.upVoted) {
        self.upVoted = NO;
        [CREParseAPIClient currentUserUpdateVote:NO forVenue:self.venue];
        [self.upvotesLabel setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName,nil] forState:UIControlStateNormal];
    } else {
        self.upVoted = YES;
        [CREParseAPIClient currentUserUpdateVote:YES forVenue:self.venue];
        [self.upvotesLabel setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16], NSFontAttributeName,nil] forState:UIControlStateNormal];
    }
    self.upvotesLabel.title = [self labelForUpvotes:self.venue.upvote_count];
}

- (NSString *) labelForUpvotes: (NSNumber *) votes {
    return [NSString stringWithFormat:@"%li votes", (long)self.venue.upvote_count.integerValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
