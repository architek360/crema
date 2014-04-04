//
//  FSQFoursquareAPIClient.h
//  Crema
//
//  Created by Jeff Wells on 1/22/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"
#import "CREVenue.h"
#import "ObjectiveSugar.h"
#import "CREParseAPIClient.h"

#define FOURSQUARE_APP_CLIENT_ID @"MQBCOLIFS53NFWIP2I0SHEKM423HZXICZN0J3DGLFSKTFURL"

#define FOURSQUARE_APP_CLIENT_SECRET @"NTFDCNNS14EBHEV22MHIP3FDIGXVUKCGRIRLBGG0B4U3CCTM"


@interface FSQFoursquareAPIClient : AFHTTPSessionManager
+ (FSQFoursquareAPIClient *) sharedClient;

- (void) searchVenuesNear:(CLLocationCoordinate2D) coordinates
              searchTerm:(NSString *) searchTerm
              completion:( void (^)(NSArray *results, NSError *error) )completion;

- (void) exploreVenuesNear:(CLLocationCoordinate2D) coordinates
                searchTerm:(NSString *) searchTerm
             includePhotos: (BOOL) includePhotos
                completion:( void (^)(NSArray *results, NSError *error) )completion;

- (void) autocompleteVenuesNear:(CLLocationCoordinate2D) coordinates
                searchTerm:(NSString *) searchTerm
                completion:( void (^)(NSArray *results, NSError *error) )completion;
@end
