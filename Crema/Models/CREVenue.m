//
//  CREVenue.m
//  Crema
//
//  Created by Jeff Wells on 1/22/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREVenue.h"
#import <Parse/Parse.h>
#import "CREParseAPIClient.h"
#import <Parse/PFObject+Subclass.h>

//#define VENUE_PHOTO_TABLE_SIZE @"44x44"

@implementation CREVenue
@dynamic venueId;
@dynamic name;
@dynamic latitude;
@dynamic longitude;
@dynamic addressString;
@dynamic saved;
@dynamic location;


+ (NSString *)parseClassName {
    return @"Venue";
}


+ (id)venueWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary: dictionary];
}

- (id) initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.venueId = dictionary[@"id"];
        self.name = dictionary[@"name"];
        
        
        id location = dictionary[@"location"];
        self.latitude = location[@"lat"];
        self.longitude = location[@"lng"];
        
        NSMutableArray * address = [[NSMutableArray alloc] init];
        if (location[@"address"]) {
            [address addObject: location[@"address"]];
        }
        if (location[@"city"]) {
            [address addObject: location[@"city"]];
        }
        if (location[@"state"]) {
            [address addObject: location[@"state"]];
        }
        if (location[@"postalCode"]) {
            [address addObject: location[@"postalCode"]];
        }
        self.addressString = [address componentsJoinedByString:@", "];
        self.location = [PFGeoPoint geoPointWithLatitude:self.latitude.doubleValue longitude:self.longitude.doubleValue];
        
//        NSDictionary *url = dictionary[@"photos"][@"groups"][0][@"items"][0];
//        if (url) {
//            self.photoUrl = [@[url[@"prefix"], VENUE_PHOTO_TABLE_SIZE, url[@"suffix"]] componentsJoinedByString:@""];
//        }
    }
    return self;
}

- (NSDictionary *)toParseDictionary {
    NSDictionary *result;
    if (self) {
        result = [self dictionaryWithValuesForKeys:@[@"venueId",@"name",@"latitude",@"longitude",@"addressString"]];
    }
    return result;
}
- (BOOL) saveToPARSE {
    if (![CREParseAPIClient venuePersisted:self]) {
        PFObject *venueObject = [PFObject objectWithClassName:@"Venue"];
        [venueObject setValuesForKeysWithDictionary:[self toParseDictionary]];
        PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:self.latitude.doubleValue longitude:self.longitude.doubleValue];
        venueObject[@"location"] = point;
        
        return [venueObject save];
    }
    return YES;
}
- (void) saveToPARSEWithBlock:(void (^)(BOOL success, NSError *failure) ) completion {
    if (![CREParseAPIClient venuePersisted:self]) {

        PFObject *venueObject = [PFObject objectWithClassName:@"Venue"];
        [venueObject setValuesForKeysWithDictionary:[self toParseDictionary]];
        PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:self.latitude.doubleValue longitude:self.longitude.doubleValue];
        venueObject[@"location"] = point;
        
        [venueObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            completion(succeeded, error);
        }];
    }
    
}

@end
