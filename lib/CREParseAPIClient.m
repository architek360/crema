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

+ (BOOL) venuePersisted: (FSQVenue * )venue {
    return [CREParseAPIClient getVenueByFSQId:venue.venueId] != nil;
}

+ (PFObject *) getVenueByFSQId: (NSString * )venueId {
    NSString *predFormat = [NSString stringWithFormat:@"venueId = '%@'", venueId];
    NSPredicate *venueIdPredicate = [NSPredicate predicateWithFormat:predFormat];
    PFQuery *query = [PFQuery queryWithClassName:@"Venue" predicate:venueIdPredicate];
    PFObject *record = [query getFirstObject];
    return record;
}

+ (NSArray *) getVenuesNear: (PFGeoPoint *) geoPoint {
    PFQuery *query = [PFQuery queryWithClassName:@"Venue"];
    [query whereKey:@"location" nearGeoPoint:geoPoint withinKilometers:5.0];
    query.limit = 20;
    NSArray *results = [query findObjects];
    return results;
    
}

+ (void) asyncVenuePersisted:(FSQVenue *) venue callback:(void (^)(BOOL success, NSError *failure) ) completion {
    NSString *predFormat = [NSString stringWithFormat:@"venueId = '%@'", venue.venueId];
    NSPredicate *venueIdPredicate = [NSPredicate predicateWithFormat:predFormat];
    PFQuery *query = [PFQuery queryWithClassName:@"Venue" predicate:venueIdPredicate];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object != nil) {
            completion(YES,error);
        } else {
            completion(NO,error);
        }
    }];
}

@end
