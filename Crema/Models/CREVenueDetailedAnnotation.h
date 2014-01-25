//
//  CREVenueDetailedAnnotation.h
//  Crema
//
//  Created by Jeff Wells on 1/24/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CREVenue.h"

@interface CREVenueDetailedAnnotation : NSObject <MKAnnotation>
    - (id)initWithVenue:(CREVenue *)venue;
@end
