//
//  CREVenueAnnotation.h
//  Crema
//
//  Created by Jeff Wells on 1/23/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "FSQVenue.h"

@interface CREVenueAnnotation : NSObject <MKAnnotation>
    - (id)initWithVenue:(FSQVenue *)venue;

@end
