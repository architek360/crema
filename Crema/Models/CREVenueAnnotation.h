//
//  CREVenueAnnotation.h
//  Crema
//
//  Created by Jeff Wells on 1/23/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CREVenue.h"

@interface CREVenueAnnotation : MKAnnotationView <MKAnnotation>

- (id)initWithVenue:(CREVenue *)venue;
@property (nonatomic, strong) CREVenue *venue;
@property (nonatomic, strong) NSIndexPath *index;

@end
