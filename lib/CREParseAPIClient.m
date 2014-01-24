//
//  CREParseAPIClient.m
//  Crema
//
//  Created by Jeff Wells on 1/23/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREParseAPIClient.h"
#import <Parse/Parse.h>
@implementation CREParseAPIClient

+ (BOOL) venuePersisted: (CREVenue * )venue {
    return [CREParseAPIClient getVenueByFSQId:venue.venueId] != nil;
}

+ (CREVenue *) getVenueByFSQId: (NSString * )venueId {
//    NSString *predFormat = [NSString stringWithFormat:@"venueId = '%@'", venueId];
//    NSPredicate *venueIdPredicate = [NSPredicate predicateWithFormat:predFormat];
//    PFQuery *query = [PFQuery queryWithClassName:@"Venue" predicate:venueIdPredicate];
    PFQuery *query = [CREVenue query];
    [query whereKey:@"venueId" equalTo:venueId];
    CREVenue *record = (CREVenue*) [query getFirstObject]; //cast
    return record;
}

+ (void) fetchVenuesNear: (PFGeoPoint *) geoPoint
                   completion:( void (^)(NSArray *results, NSError *error) )completion
{
    PFQuery *query = [CREVenue query];
    //    PFQuery *query = [PFQuery queryWithClassName:@"Venue"];
    [query whereKey:@"location" nearGeoPoint:geoPoint withinKilometers:5.0];

    //    [query orderByAscending:@"upvotes"];
    query.limit = 20;
    NSArray *results = [query findObjects];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completion(results,error);
    }];
}

+ (void) asyncVenuePersisted:(CREVenue *) venue callback:(void (^)(BOOL success, NSError *failure) ) completion {
//    NSString *predFormat = [NSString stringWithFormat:@"venueId = '%@'", venue.venueId];
//    NSPredicate *venueIdPredicate = [NSPredicate predicateWithFormat:predFormat];
//    PFQuery *query = [CREVenue queryWithClassName:@"Venue" predicate:venueIdPredicate];
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

@end
