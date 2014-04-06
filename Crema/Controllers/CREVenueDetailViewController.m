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
    self.upVoted = YES;
    
    [self setBottomLabel];
}

- (void) setBottomLabel {
    
    self.upvotesLabel.title = [self labelForUpvotes:self.venue.upvote_count];
    
    if([PFUser currentUser] && [CREParseAPIClient currentUserLikesVenue:self.venue])
    {
        self.upVoted = [CREParseAPIClient currentUserLikesVenue:self.venue];

        [self styleUpvoteLabel];
    }
}

- (void) styleUpvoteLabel {
    
    if (self.upVoted) {
        [self.upvotesLabel setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16], NSFontAttributeName,nil] forState:UIControlStateNormal];
    } else {
        [self.upvotesLabel setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName,nil] forState:UIControlStateNormal];
    }
    
}

- (IBAction)tapVoteCount:(id)sender {
    if (![PFUser currentUser]){
        [self performSegueWithIdentifier:@"flipToLogin" sender:self];
        return;
    }
    [SVProgressHUD showWithStatus:@"Submitting Vote"];
    self.upVoted = !self.upVoted;
    [CREParseAPIClient currentUserUpdateVote:self.upVoted forVenue:self.venue callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"Done!"];
            self.upvotesLabel.title = [self labelForUpvotes:self.venue.upvote_count];
            [self styleUpvoteLabel];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Error!"];
        }
        
    }];
    
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
