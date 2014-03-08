//
//  CREVenueCollection.h
//  Crema
//
//  Created by Jeff Wells on 3/7/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFGeoBox.h"
#import "SVProgressHUD.h"
#import "ObjectiveSugar.h"
#import <UIKit/UIKit.h>
#import "CREVenue.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "CREParseAPIClient.h"


@interface CREVenueCollection : NSObject

+ (id) venues;
@end
