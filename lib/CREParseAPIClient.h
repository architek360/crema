//
//  CREParseAPIClient.h
//  Crema
//
//  Created by Jeff Wells on 1/23/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSQVenue.h"
#import <Parse/Parse.h>
@interface CREParseAPIClient : NSObject

+ (BOOL) venuePersisted: (FSQVenue * )venue;
+ (PFObject *) getVenueByFSQId: (NSString * )venueId;
+ (NSArray *) getVenuesNear: (PFGeoPoint *) geoPoint;
+ (void) asyncVenuePersisted:(FSQVenue *) venue callback:(void (^)(BOOL success, NSError *failure) ) completion;

@end
