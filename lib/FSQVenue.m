//
//  FSQVenue.m
//  Crema
//
//  Created by Jeff Wells on 1/22/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "FSQVenue.h"

#define VENUE_PHOTO_TABLE_SIZE @"44x44"

@implementation FSQVenue

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
        
//        NSDictionary *url = dictionary[@"photos"][@"groups"][0][@"items"][0];
//        if (url) {
//            self.photoUrl = [@[url[@"prefix"], VENUE_PHOTO_TABLE_SIZE, url[@"suffix"]] componentsJoinedByString:@""];
//        }
    }
    return self;
}



@end
