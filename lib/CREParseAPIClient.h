//
//  CREParseAPIClient.h
//  Crema
//
//  Created by Jeff Wells on 1/23/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CREVenue.h"
#import "PFGeoBox.h"
#import "CREAppDelegate.h"
#import "ObjectiveSugar.h"
@interface CREParseAPIClient : NSObject

+ (BOOL) venuePersisted: (CREVenue * )venue;
+ (CREVenue *) getVenueByFSQId: (NSString * )venueId;
+ (void) fetchVenuesInView: (PFGeoBox *) geoBox
                    page: (NSInteger) page
              completion: ( void (^)(NSArray *results, NSError *error) )completion;

+ (void) asyncVenuePersisted:(CREVenue *) venue callback:(void (^)(BOOL success, NSError *failure) ) completion;
//+ (void) getFriendsWhoLikeVenue: (CREVenue *) venue callback:(void (^)(NSArray *friends, NSError *failure) ) completion;
+ (BOOL) currentUserLikesVenue: (CREVenue *) venue;
+ (void) currentUserUpdateVote: (BOOL) status forVenue: (CREVenue *) venue callback: (void (^)(BOOL succeeded, NSError *error) ) completion;
//+ (NSInteger) upvotesForVenue: (CREVenue *) venue;
@end
