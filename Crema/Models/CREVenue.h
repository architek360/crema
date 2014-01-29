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
@interface CREVenue : PFObject<PFSubclassing,MKAnnotation>

+ (NSString *)parseClassName; //for Parse


@property (nonatomic, copy) NSString *venueId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, copy) NSString *addressString;
@property (nonatomic, strong) NSNumber *saved;
@property (nonatomic, strong) NSNumber *upvotes;
@property (nonatomic, strong) PFGeoPoint *location;
//@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, assign) BOOL animatesDrop;


+ (id)venueWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toParseDictionary;
- (BOOL) saveToPARSE;
- (void) saveToPARSEWithBlock: (void (^)(BOOL success, NSError *failure) ) completion;

@end
