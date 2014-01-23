//
//  CRESearchTableViewController.h
//  Crema
//
//  Created by Jeff Wells on 1/19/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
@interface CRESearchTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic) CLLocation *location;
@end
