//
//  CREVenueAnnotation.m
//  Crema
//
//  Created by Jeff Wells on 1/23/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREVenueAnnotation.h"


@interface CREVenueAnnotation ()
@property (nonatomic, strong) PFObject *venue;
@end


@implementation CREVenueAnnotation

- (id)initWithVenue:(PFObject *)venue {
    self = [super init];
    if (self) {
        self.venue = venue;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    
    return CLLocationCoordinate2DMake([self.venue[@"latitude"] doubleValue], [self.venue[@"longitude"] doubleValue]);
}

- (NSString *)title {
    return self.venue[@"name"];
}

@end
