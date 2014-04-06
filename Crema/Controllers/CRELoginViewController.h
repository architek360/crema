//
//  CRELoginViewController.h
//  Crema
//
//  Created by Jeff Wells on 1/29/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CREAppDelegate.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface CRELoginViewController : UIViewController

- (IBAction)pressedFacebookLogin:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *facebookConnectButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookConnectDesc;

@property (strong, nonatomic) IBOutlet UIImageView *userPhoto;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIButton *logOutButton;

- (IBAction)pressedLogout:(id)sender;

@end
