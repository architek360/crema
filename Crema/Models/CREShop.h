//
//  CREShop.h
//  Crema
//
//  Created by Jeff Wells on 1/19/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CREShop : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longitude;

+ (instancetype)createWithName:(NSString *)name latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;

@end
