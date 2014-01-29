//
//  CRESettingsViewController.m
//  Crema
//
//  Created by Jeff Wells on 1/29/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CRESettingsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"

@interface CRESettingsViewController ()

@end

@implementation CRESettingsViewController
@synthesize userProfileImage;
@synthesize userNameLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square&return_ssl_resources=1", facebookID]];
            
            [userProfileImage setImageWithURL:pictureURL placeholderImage:[UIImage imageNamed:@"placeholder-placeholder.jpeg"]];
            [userProfileImage.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
            [userProfileImage.layer setBorderWidth: 2.0];
            userNameLabel.text = name;
            
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
