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

@interface CRELoginViewController : UIViewController

- (IBAction)pressedFacebookLogin:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
