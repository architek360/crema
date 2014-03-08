//
//  CREListViewController.h
//  Crema
//
//  Created by Jeff Wells on 2/28/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CREVenueCollection.h"
#import "SVProgressHUD.h"
#import "ObjectiveSugar.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface CREListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
