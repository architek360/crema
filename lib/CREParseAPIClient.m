//
//  CREParseAPIClient.m
//  Crema
//
//  Created by Jeff Wells on 1/23/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREParseAPIClient.h"
#import "CREAppDelegate.h"
#import <Parse/Parse.h>
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

+ (void) fetchVenuesNear: (PFGeoPoint *) geoPoint
                    page: (NSInteger) page
                   completion:( void (^)(NSArray *results, NSError *error) )completion
{
    PFQuery *query = [CREVenue query];
    [query whereKey:@"location" nearGeoPoint:geoPoint withinKilometers:5.0];

    //    [query orderByAscending:@"upvotes"];
    query.limit = kCREVenuesPerPage;
    if (page) {
        query.skip = kCREVenuesPerPage * page;
    }

//    [query whereKey:<#(NSString *)#> withinGeoBoxFromSouthwest:<#(PFGeoPoint *)#> toNortheast:<#(PFGeoPoint *)#>]
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

@end
