//
//  CRELoginViewController.m
//  Crema
//
//  Created by Jeff Wells on 1/29/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CRELoginViewController.h"
#import "AFNetworking.h"

@interface CRELoginViewController ()

@end

@implementation CRELoginViewController
@synthesize facebookConnectButton;
@synthesize facebookConnectDesc;
@synthesize userPhoto;
@synthesize userName;
@synthesize logOutButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void) viewWillAppear:(BOOL)animated {
    [self displayUserStatus];
}

#pragma makr - User status

- (void)displayUserStatus
{
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        [facebookConnectButton removeFromSuperview];
        [facebookConnectDesc removeFromSuperview];
        
        
        FBRequest *request = [FBRequest requestForMe];
        
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSDictionary *userData = (NSDictionary *)result;
                
                NSString *facebookID = userData[@"id"];
                NSString *name = userData[@"name"];
                
                NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?height=100&width=100&return_ssl_resources=1", facebookID]];
                
                [userPhoto setImageWithURL:pictureURL placeholderImage:[UIImage imageNamed:@"placeholder-placeholder.jpeg"]];
                [userPhoto.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
                [userPhoto.layer setBorderWidth: 2.0];
                [userPhoto.layer setOpacity:0.9];
                userName.text = name;
                
            }
        }];
    } else {
        [userPhoto removeFromSuperview];
        [userName removeFromSuperview];
        [logOutButton removeFromSuperview];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedFacebookLogin:(id)sender {
    [SVProgressHUD show];
    
    
    [CREAppDelegate logInFacebook:^(PFUser *aUser, NSError *failure) {
        [SVProgressHUD dismiss];
        [self loadView];
        [self viewWillAppear:NO];
    }];
    
}


- (IBAction)pressedLogout:(id)sender {
    [PFUser logOut];
    [self loadView];
    [self viewWillAppear:NO];
}


@end
