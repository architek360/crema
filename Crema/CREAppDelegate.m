//
//  CREAppDelegate.m
//  Crema
//
//  Created by Jeff Wells on 1/18/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREAppDelegate.h"
#import <Parse/Parse.h>
#import "CREVenue.h"

#define FOURSQUARE_API_KEY


@implementation CREAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [CREVenue registerSubclass];
    [Parse setApplicationId:@"XopwGca2iFLDzrpCbccC64fKlIxlwVG7QpXNJODI"
                  clientKey:@"cJcLuyfspI5uc0tEq6mBsgi2zcbVA9svXOavhF2o"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        
    [PFFacebookUtils initializeFacebook];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}


+ (void) logInFacebook:(void (^)(PFUser *aUser, NSError *failure) ) completion
{
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships"];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                             forKey:@"facebookId"];
                    [[PFUser currentUser] setObject:[result objectForKey:@"name"]
                                             forKey:@"name"];
                    [[PFUser currentUser] setObject:[result objectForKey:@"first_name"]
                                             forKey:@"first_name"];
                    [[PFUser currentUser] setObject:[result objectForKey:@"last_name"]
                                             forKey:@"last_name"];
                    [[PFUser currentUser] saveInBackground];
                }
            }];
            NSLog(@"User with facebook signed up and logged in!");
            completion(user, error);
        } else {
            NSLog(@"User with facebook logged in!");
            completion(user,error);
        }
    }];

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
