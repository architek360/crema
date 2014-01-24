//
//  CRESearchTableViewController.m
//  Crema
//
//  Created by Jeff Wells on 1/19/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CRESearchTableViewController.h"
#import "AFNetworking.h"
#import "CREVenue.h"
#import "SVProgressHUD.h"
#import "FSQFoursquareAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "CREReviewNewViewController.h"
#import "CREParseAPIClient.h"
#import "ObjectiveSugar.h"


@interface CRESearchTableViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic) NSMutableArray *searchResults;

@end

@implementation CRESearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateLocation];
}

- (void) updateLocation {
    [self.locationManager startUpdatingLocation];
}

- (CLLocationManager *)locationManager {
    if(!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location  = [locations lastObject];
    [self exploreCoffeeVenuesNear: self.location includePhotos: NO];
    [self.locationManager stopUpdatingLocation];
}

- (void) exploreCoffeeVenuesNear: (CLLocation *) location includePhotos: (BOOL) includePhotos{
    [self exploreVenuesByLocation:location searchTerm: @"coffee" includePhotos:includePhotos];
}

- (void) exploreVenuesByLocation: (CLLocation *)location searchTerm: (NSString *) keyword includePhotos: (BOOL) photos {
    [SVProgressHUD showWithStatus:@"Searching"];
    [[FSQFoursquareAPIClient sharedClient]  exploreVenuesNear:location.coordinate
                                                searchTerm: keyword
                                                includePhotos: photos
                                                completion:^(NSArray *results, NSError *error) {
                                                    if (error) {
                                                        [SVProgressHUD showErrorWithStatus:@"Sorry, an error occurred"];
                                                    } else {
                                                        [SVProgressHUD dismiss];
                                                        self.searchResults = [results mutableCopy];
                                                        [self.tableView reloadData];
                                                    }
                                                }];
}

- (void) searchVenuesByLocation: (CLLocation *)location searchTerm: (NSString *) keyword {
    [SVProgressHUD showWithStatus:@"Searching"];
    [[FSQFoursquareAPIClient sharedClient] searchVenuesNear:location.coordinate
                                                searchTerm: keyword
                                                completion:^(NSArray *results, NSError *error) {
                                                    if (error) {
                                                        [SVProgressHUD showErrorWithStatus:@"Sorry, an error occurred"];
                                                    } else {
                                                        [SVProgressHUD dismiss];
                                                        self.searchResults = [results mutableCopy];
                                                        [self.tableView reloadData];
                                                    }
                                                }];
}

- (void) autocompleteVenuesByLocation: (CLLocation *)location searchTerm: (NSString *) keyword {
    [SVProgressHUD showWithStatus:@"Searching"];
    [[FSQFoursquareAPIClient sharedClient] autocompleteVenuesNear:location.coordinate
                                                 searchTerm: keyword
                                                 completion:^(NSArray *results, NSError *error) {
                                                     if (error) {
                                                         [SVProgressHUD showErrorWithStatus:@"Sorry, an error occurred"];
                                                     } else {
                                                         [SVProgressHUD dismiss];
                                                         self.searchResults = [results mutableCopy];
                                                         [self.tableView reloadData];
                                                     }
                                                 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"AddNewSearchListCell";
    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	CREVenue *venue;
    
	venue = [self.searchResults objectAtIndex:indexPath.row];
    if (venue.saved == nil)
    {
        [CREParseAPIClient asyncVenuePersisted:venue callback:^(BOOL persisted, NSError *failure) {
            venue.saved = [NSNumber numberWithBool:persisted];
            if (persisted) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            [cell reloadInputViews];
        }];
    } else {
        if ([venue.saved isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
	cell.textLabel.text = venue.name;
    [cell.detailTextLabel setText:venue.addressString];

    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CREVenue *venue = self.searchResults[indexPath.row];
    
    if (venue.saved == nil) {
        venue.saved = [NSNumber numberWithBool:[CREParseAPIClient venuePersisted:venue]];
    }

    if ([venue.saved isEqualToNumber:[NSNumber numberWithBool:YES]]) return nil;
    
    return indexPath;
}
#pragma mark - Content Filtering


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushDetailView"])
    {
        NSIndexPath *indexPath;
        
        if (self.searchDisplayController.active) {
            NSLog(@"Search Display Controller");
            indexPath = self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow;
        } else {
            NSLog(@"Default Display Controller");
            indexPath = self.tableView.indexPathForSelectedRow;
        }
        
        CREReviewNewViewController *destinationController = [segue destinationViewController];
        CREVenue *venue = self.searchResults[indexPath.row];
        destinationController.venue = venue;
        destinationController.index = indexPath;
    }
}

- (IBAction)unwindToTable:(UIStoryboardSegue *)segue
{
    CREReviewNewViewController *source = [segue sourceViewController];
    CREVenue *venue = source.venue;
    [self.searchResults replaceObjectAtIndex:source.index.row withObject:venue];
    [self.tableView reloadRowsAtIndexPaths:@[source.index] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [SVProgressHUD showWithStatus:@"Searching"];
    
    if ([searchString length] == 0) {
        [self exploreCoffeeVenuesNear:self.location includePhotos:NO];
        return YES;
    }
    
    if ([searchString length] < 3) {
        return NO;
    }
    
    if ([searchString length] >= 3) {
        [self autocompleteVenuesByLocation:self.location searchTerm:searchString];
    }
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}



@end
