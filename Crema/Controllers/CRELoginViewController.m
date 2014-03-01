//
//  CRELoginViewController.m
//  Crema
//
//  Created by Jeff Wells on 1/29/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CRELoginViewController.h"
#import <Parse/Parse.h>
#import "CREAppDelegate.h"

@interface CRELoginViewController ()

@end

@implementation CRELoginViewController
@synthesize activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
	if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        [self performSegueWithIdentifier:@"flipToMap" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedFacebookLogin:(id)sender {
    [activityIndicator startAnimating];
    
    
    [CREAppDelegate logInFacebook:^(PFUser *aUser, NSError *failure) {
        [activityIndicator stopAnimating];
        [self performSegueWithIdentifier:@"flipToMap" sender:self];
    }];
    
}

@end
