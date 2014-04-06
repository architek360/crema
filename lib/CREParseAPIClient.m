//
//  CREParseAPIClient.m
//  Crema
//
//  Created by Jeff Wells on 1/23/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREParseAPIClient.h"

@implementation CREParseAPIClient

+ (BOOL) venuePersisted: (CREVenue * )venue {
    return [CREParseAPIClient getVenueByFSQId:venue.venueId] != nil;
}

+ (CREVenue *) getVenueByFSQId: (NSString * )venueId {
    PFQuery *query = [CREVenue query];
    [query whereKey:@"venueId" equalTo:venueId];
    CREVenue *record = (CREVenue*) [query getFirstObject]; //cast
    return record;
}

+ (void) fetchVenuesInView:(PFGeoBox *)geoBox
                      page:(NSInteger)page
                completion:(void (^)(NSArray *, NSError *))completion
{
    PFQuery *query = [CREVenue query];
    
    [query whereKey:@"location" withinGeoBoxFromSouthwest:geoBox.southwest toNortheast:geoBox.northeast];
//    [query includeKey:@"upvotes"];
    [query orderByDescending:@"upvote_count"];
    
    query.limit = kCREVenuesPerPage;
    
    if (page != 0 && page) {
        query.skip = kCREVenuesPerPage * page;
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completion(objects,error);
    }];
}

+ (void) asyncVenuePersisted:(CREVenue *) venue callback:(void (^)(BOOL success, NSError *failure) ) completion {
    
    PFQuery *query = [CREVenue query];
    [query whereKey:@"venueId" equalTo:venue.venueId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object != nil) {
            completion(YES,error);
        } else {
            completion(NO,error);
        }
    }];
}
// TODO
//+ (void) getFriendsWhoLikeVenue: (CREVenue *) venue callback:(void (^)(NSArray *friends, NSError *failure) ) completion
//{
//
//    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
//    
//    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
//                                                  NSDictionary* result,
//                                                  NSError *error) {
//        
//        NSArray* friendIds = [[result objectForKey:@"data"] map:^(NSDictionary<FBGraphUser>* friend) {
//            return friend.id;
//        }];
//        PFQuery *friendQuery = [PFUser query];
//        [friendQuery whereKey:@"facebookId" containedIn:friendIds];
////        [friendQuery findObjects];
//        
//        PFRelation *venueRelation = [venue relationForKey:@"upvotes"];
//        
//        PFQuery *venueQuery = [venueRelation query];
//        NSArray *venuePeople = [venueQuery findObjects];
//        
//        [venueQuery whereKey:@"facebookId" containedIn:friendIds];
//        
//        
////        NSArray *friendUsers = [friendQuery findObjects];
//        NSArray *venueFriends = [venueQuery findObjects];
////        NSLog(@"Friends: %@", friendUsers);
////        NSLog(@"VenueFriends: %@", venueFriends);
////        NSLog(@"VenuePeople: %@", venuePeople);
//        
//    }];
//    
//}

// TODO
//+ (NSInteger) upvotesForVenue: (CREVenue *) venue
//{
//    PFRelation *venueRelation = [venue relationForKey:@"upvotes"];
//    PFQuery *venueQuery = [venueRelation query];
//    return [venueQuery countObjects];
//}


+ (BOOL) currentUserLikesVenue: (CREVenue *) venue
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [venue relationforKey:@"upvotes"];
    PFQuery *query = [relation query];
    [query whereKey:@"facebookId" equalTo:user[@"facebookId"]];
    NSInteger count = [query countObjects];
    return (count != 0);
}

+ (void) currentUserUpdateVote: (BOOL) status forVenue: (CREVenue *) venue callback: (void (^)(BOOL succeeded, NSError *error) ) completion
{
    PFObject *user = (PFObject *) [PFUser currentUser];
    PFRelation *relation = [venue relationforKey:@"upvotes"];
    if (status) {
        [relation addObject: user];
        [venue incrementKey:@"upvote_count"];
    } else {
        [relation removeObject:user];
        [venue decrementKey:@"upvote_count"];
    }
    
    [venue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(succeeded,error);
    }];
   
    
}


@end
