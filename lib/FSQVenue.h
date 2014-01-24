//
//  FSQVenue.h
//  Crema
//
//  Created by Jeff Wells on 1/22/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface FSQVenue : NSObject
@property (nonatomic, copy) NSString *venueId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, copy) NSString *addressString;
//@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, strong) NSNumber *saved;

+ (id)venueWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toParseDictionary;
- (BOOL) saveToPARSE;
- (void) saveToPARSEWithBlock: (void (^)(BOOL success, NSError *failure) ) completion;

@end
