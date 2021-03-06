//
//  CREAppDelegate.h
//  Crema
//
//  Created by Jeff Wells on 1/18/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
static NSString* const kCRELocationChangeNotification= @"kCRELocationChangeNotification";
static NSUInteger const kCREVenuesPerPage = 8;

@interface CREAppDelegate : UIResponder <UIApplicationDelegate>
+ (void) logInFacebook:(void (^)(PFUser *aUser, NSError *failure) ) completion;
@property (strong, nonatomic) UIWindow *window;

@end
