//
//  FSQFoursquareAPIClient.m
//  Crema
//
//  Created by Jeff Wells on 1/22/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "FSQFoursquareAPIClient.h"


#define FOURSQUARE_BASE_URL @"https://api.foursquare.com/v2/"
#define VENUE_PHOTO_TABLE_SIZE @"320x205"


@implementation FSQFoursquareAPIClient
+ (FSQFoursquareAPIClient *) sharedClient {
    static FSQFoursquareAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:FOURSQUARE_BASE_URL];
        _sharedClient = [[FSQFoursquareAPIClient alloc] initWithBaseURL:baseUrl];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"CremaApp iOS 1.0"}];
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        [config setURLCache:cache];
        _sharedClient = [[FSQFoursquareAPIClient alloc] initWithBaseURL:baseUrl
                                         sessionConfiguration:config];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        
    });
    
    return _sharedClient;
}

- (void) searchVenuesNear:(CLLocationCoordinate2D) coordinates
              searchTerm:(NSString *) searchTerm
              completion:( void (^)(NSArray *results, NSError *error) )completion
{
    id params = [self buildAuthParameters:@{
                                            @"ll": [self latLongValueForCoordinate: coordinates],
                                            @"query": searchTerm,
                                            @"intent": @"browse"
                                            }
                 ];
    
    [self GET:@"venues/search"
   parameters:params
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSArray *venues = [self venuesForResponse: responseObject[@"response"][@"venues"]];
          completion(venues,nil);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"Response: %@", task.response);
          NSLog(@"Error: %@", error);
          completion(nil, error);
      }];
 
}

- (void) exploreVenuesNear:(CLLocationCoordinate2D) coordinates
              searchTerm: (NSString *) searchTerm
           includePhotos: (BOOL) includePhotos
              completion: ( void (^)(NSArray *results, NSError *error) )completion
{
    id params = [self buildAuthParameters:@{
                                            @"ll": [self latLongValueForCoordinate: coordinates],
                                            @"query": searchTerm,
                                            @"venuePhotos": includePhotos ? @"1" : @"0"
                                            }
                 ];
    
    [self GET:@"venues/explore"
   parameters:params
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSLog(@"Response: %@", task.response);
          NSArray *items = responseObject[@"response"][@"groups"][0][@"items"];
          NSArray *maps = [items map:^(NSDictionary* item){
              return item[@"venue"];
          }];
          NSArray *venues = [self venuesForResponse:maps];
          completion(venues,nil);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"Response: %@", task.response);
          NSLog(@"Error: %@", error);
          completion(nil, error);
      }];
    
}



- (void) autocompleteVenuesNear:(CLLocationCoordinate2D) coordinates
                searchTerm:(NSString *) searchTerm
                completion:( void (^)(NSArray *results, NSError *error) )completion
{
    id params = [self buildAuthParameters:@{
                                            @"ll": [self latLongValueForCoordinate: coordinates],
                                            @"query": searchTerm
                                            }
                 ];
    
    [self GET:@"venues/suggestCompletion"
   parameters:params
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSLog(@"Response: %@", task.response);
          NSArray *venues = [self venuesForResponse: responseObject[@"response"][@"minivenues"]];
          completion(venues,nil);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"Response: %@", task.response);
          NSLog(@"Error: %@", error);
          completion(nil, error);
      }];
    
}



- (void) getPhotosForVenue:(CREVenue *) venue completion:( void (^)(NSArray *urls, NSError *error) )completion {
    NSString * url = [@[@"venues/",venue.venueId, @"/photos"] componentsJoinedByString:@""];
    id params = [self buildAuthParameters:@{
                                            @"group": @"venue",
                                            @"limit": @"10"
                                            }
                 ];
    
    [self GET:url
   parameters:params
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSLog(@"GET PHOTOS Response: %@", task.response);
          NSArray *items = responseObject[@"response"][@"photos"][@"items"];
          NSArray *urls = [items map:^(NSDictionary* item){
              return [@[item[@"prefix"], VENUE_PHOTO_TABLE_SIZE, item[@"suffix"]] componentsJoinedByString:@""];
          }];
          completion(urls,nil);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"REQUEST: %@, ERROR: %@",task, error);
          completion(nil, error);
      }];
}


         
- (NSDictionary *) buildAuthParameters: (NSDictionary *)parameters {
    NSMutableDictionary *params = [parameters mutableCopy];
    [params setObject:FOURSQUARE_APP_CLIENT_ID forKey:@"client_id"];
    [params setObject:FOURSQUARE_APP_CLIENT_SECRET forKey:@"client_secret"];
    [params setObject:@"20140122" forKey:@"v"];
    
    return params;
}
         
//FOURSQUARE_APP_CLIENT_ID
//FOURSQUARE_APP_CLIENT_SECRET

- (NSString *)latLongValueForCoordinate:(CLLocationCoordinate2D)coord {
    return [NSString stringWithFormat:@"%g,%g", coord.latitude, coord.longitude];
}

- (NSArray *) venuesForResponse: (NSArray *) venueDictionaries {
    NSMutableArray *venues = [NSMutableArray arrayWithCapacity:[venueDictionaries count]];
    for (id venueDictionary in venueDictionaries) {
        [venues addObject:[CREVenue venueWithDictionary: venueDictionary]];
    }
    return venues;
}




@end
