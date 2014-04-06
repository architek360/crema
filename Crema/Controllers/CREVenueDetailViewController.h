//
//  CREVenueDetailViewController.h
//  Crema
//
//  Created by Jeff Wells on 1/25/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CREVenue.h"
#import "CREParseAPIClient.h"
#import "SVProgressHUD.h"

@interface CREVenueDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *upvotesLabel;

- (IBAction)tapVoteCount:(id)sender;

@property (nonatomic) CREVenue *venue;
@property (nonatomic) NSIndexPath *index;
@end
