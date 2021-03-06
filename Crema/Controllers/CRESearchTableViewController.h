//
//  CRESearchTableViewController.h
//  Crema
//
//  Created by Jeff Wells on 1/19/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "AFNetworking.h"
#import "CREVenue.h"
#import "SVProgressHUD.h"
#import "FSQFoursquareAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "CREReviewNewViewController.h"
#import "CREParseAPIClient.h"
#import "ObjectiveSugar.h"

@interface CRESearchTableViewController : UIViewController <UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) CLLocation *location;
@property(nonatomic, readonly, retain) UISearchDisplayController *searchDisplayController;

@end
