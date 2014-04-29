//
//  CREVenue.h
//  Crema
//
//  Created by Jeff Wells on 1/22/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <Parse/PFObject+Subclass.h>

@interface CREVenue : PFObject<PFSubclassing,MKAnnotation>

+ (NSString *)parseClassName; //for Parse


@property (nonatomic, copy) NSString *venueId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, copy) NSString *addressString;
@property (nonatomic, strong) NSNumber *saved;
@property (nonatomic) NSNumber *upvotes;
@property (nonatomic) NSNumber *upvote_count;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, copy) NSArray *photoUrls;
@property (nonatomic, assign) BOOL animatesDrop;
@property NSUInteger imageIndex;


+ (id)venueWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toParseDictionary;
- (BOOL) saveToPARSE;
- (void) saveToPARSEWithBlock: (void (^)(BOOL success, NSError *failure) ) completion;
- (void) decrementKey: (NSString *) key;
- (NSString *) upvoteCountString;

@end
