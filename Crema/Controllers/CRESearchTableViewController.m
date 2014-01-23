//
//  CRESearchTableViewController.m
//  Crema
//
//  Created by Jeff Wells on 1/19/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CRESearchTableViewController.h"
#import "AFNetworking.h"
#import "CREShop.h"
#import "FSQVenue.h"
#import "SVProgressHUD.h"
#import "FSQFoursquareAPIClient.h"
#import "UIImageView+AFNetworking.h"



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
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.searchResults count];
    }
	else
	{
        return [self.searchResults count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"AddNewSearchListCell";
    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	FSQVenue *venue;
    
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        venue = [self.searchResults objectAtIndex:indexPath.row];
    }
	else
	{
        venue = [self.searchResults objectAtIndex:indexPath.row];
    }
    
	cell.textLabel.text = venue.name;
    [cell.detailTextLabel setText:venue.addressString];

    return cell;
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForShopName:(NSString *)shopName
{

	/*
	 Update the filtered array based on the search text and scope.
	 */
//    if ((shopName == nil) || [shopName length] == 0)
//    {
//        self.searchResults = [self.shops mutableCopy];
//        return;
//    }
//    
//    
//    [self.searchResults removeAllObjects]; // First clear the filtered array.
//	/*
//	 Search the main list for shops whose name matches searchText; add items that match to the filtered array.
//	 */
//    for (CREShop *shop in self.shops)
//	{
//        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
//        NSRange shopNameRange = NSMakeRange(0, shop.name.length);
//        NSRange foundRange = [shop.name rangeOfString:shopName options:searchOptions range:shopNameRange];
//        if (foundRange.length > 0)
//        {
//            [self.searchResults addObject:shop];
//        }
//	}
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
//        [self updateFilteredContentForShopName:searchString];
    }
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
