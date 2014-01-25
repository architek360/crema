//
//  CREVenueDetailedAnnotation.m
//  Crema
//
//  Created by Jeff Wells on 1/24/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREVenueDetailedAnnotation.h"

@interface CREVenueDetailedAnnotation ()
@property (nonatomic, strong) CREVenue *venue;
@end

@implementation CREVenueDetailedAnnotation

- (id)initWithVenue:(CREVenue *)venue {
    self = [super init];
    if (self) {
        self.venue = venue;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    
    return CLLocationCoordinate2DMake(self.venue.latitude.doubleValue, self.venue.longitude. doubleValue);
}

- (NSString *)title {
    return self.venue.name;
}

- (NSString *) subtitle {
    return self.venue.addressString;
}

@end
