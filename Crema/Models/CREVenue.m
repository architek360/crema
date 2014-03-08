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
@dynamic upvotes;
@dynamic upvote_count;
@synthesize animatesDrop;


+ (NSString *)parseClassName {
    return @"Venue";
}

- (NSString *) upvoteCountString
{
    if (self.upvote_count == nil)
    {
        return @"0";
    } else {
        return [NSString stringWithFormat:@"%@", self.upvote_count];
    }
}

- (void) decrementKey:(NSString *)key
{
    if (self.upvote_count != 0)
    {
        self.upvote_count = [NSNumber numberWithInt:(self.upvote_count.intValue - 1)];
    }
}
+ (id)venueWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary: dictionary];
}

- (id) initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.venueId = dictionary[@"id"];
        self.name = dictionary[@"name"];
        if (dictionary[@"upvote_count"]) {
            self.upvote_count = dictionary[@"upvote_count"];
        } else {
            self.upvote_count = [NSNumber numberWithInt:0];
        }
        
        
        
        
        id locationDictionary = dictionary[@"location"];
        self.latitude = locationDictionary[@"lat"];
        self.longitude = locationDictionary[@"lng"];
        
        NSMutableArray * address = [[NSMutableArray alloc] init];
        if (locationDictionary[@"address"]) {
            [address addObject: locationDictionary[@"address"]];
        }
        if (locationDictionary[@"city"]) {
            [address addObject: locationDictionary[@"city"]];
        }
        if (locationDictionary[@"state"]) {
            [address addObject: locationDictionary[@"state"]];
        }
        if (locationDictionary[@"postalCode"]) {
            [address addObject: locationDictionary[@"postalCode"]];
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
        result = [self dictionaryWithValuesForKeys:@[@"venueId",@"name", @"upvotes",@"latitude",@"longitude",@"addressString"]];
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

#pragma mark - MKAnnotation methods

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}

- (NSString *)title {
    return self.name;
}

- (NSString *) subtitle {
    return self.addressString;
}

@end
