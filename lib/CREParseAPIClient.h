//
//  CREParseAPIClient.h
//  Crema
//
//  Created by Jeff Wells on 1/23/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CREVenue.h"
#import <Parse/Parse.h>
#import "PFGeoBox.h"
@interface CREParseAPIClient : NSObject

+ (BOOL) venuePersisted: (CREVenue * )venue;
+ (CREVenue *) getVenueByFSQId: (NSString * )venueId;
+ (void) fetchVenuesInView: (PFGeoBox *) geoBox
                    page: (NSInteger) page
              completion: ( void (^)(NSArray *results, NSError *error) )completion;

+ (void) asyncVenuePersisted:(CREVenue *) venue callback:(void (^)(BOOL success, NSError *failure) ) completion;
@end
