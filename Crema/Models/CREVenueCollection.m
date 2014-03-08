//
//  CREVenueCollection.m
//  Crema
//
//  Created by Jeff Wells on 3/7/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//


#import "CREVenueCollection.h"

@implementation CREVenueCollection


#pragma mark Class variable

//create the static account to act as class variable
static NSMutableArray *venues;

// singleton class variable for storing the venues
+ (id) venues
{
    if (venues == NULL) {
        venues = [NSMutableArray new];
    }
    return venues;
}


@end
