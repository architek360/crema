//
//  CREShop.m
//  Crema
//
//  Created by Jeff Wells on 1/19/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREShop.h"

@implementation CREShop

+ (instancetype)createWithName:(NSString *)name latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;
{
	CREShop *newShop = [[self alloc] init];
	newShop.name = name;
    newShop.latitude = latitude;
    newShop.longitude = longitude;
	return newShop;
}

@end
