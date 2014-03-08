//
//  CREListViewController.m
//  Crema
//
//  Created by Jeff Wells on 2/28/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREListViewController.h"
#import "CREVenue.h"

const int kLoadingCellTag = 1273;


@interface CREListViewController ()

@property (nonatomic) BOOL isLoading;

@end

@implementation CREListViewController
@synthesize isLoading;

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    return [[CREVenueCollection venues] count]; // + 1 for loading cell
}


//- (void) showSpinnerOnLoadingCell
//{
//    isLoading = YES;
//    NSIndexPath *index = [NSIndexPath indexPathForRow:[self.venues count] inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
//}

//- (UITableViewCell *)loadingCellWithSpinner
//{
//    
//    static NSString *CellIdentifier = @"loadingCell";
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    activityIndicator.center = cell.center;
//    [cell addSubview:activityIndicator];
//    
//    [activityIndicator startAnimating];
//    
//    cell.tag = kLoadingCellTag;
//    cell.textLabel.text = @"";
//    
//    return cell;
//}

//- (UITableViewCell *)loadingCell
//{
//    
//    static NSString *CellIdentifier = @"loadingCell";
//    
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    cell.tag = kLoadingCellTag;
//    cell.textLabel.text = @"click to load more shops";
//    
//    return cell;
//}

//- (UITableViewCell *)venueCellForIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"MapListCell";
//    
//    TDBadgedCell *cell = (TDBadgedCell *) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    //    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//	CREVenue *venue;
//    
//	venue = (CREVenue*) [self.venues objectAtIndex:indexPath.row];
//    
//	cell.textLabel.text = venue.name;
//    cell.badgeString = [venue upvoteCountString];
//    cell.badge.radius = 4;
//    [cell.detailTextLabel setText:venue.addressString];
//    
//    return cell;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"venueCell";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CREVenue *venue;
    
    venue = (CREVenue*) [[CREVenueCollection venues] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = venue.name;
    [cell.detailTextLabel setText:venue.addressString];
    
    return cell;

    
    
//  for loading cell
    
//    if (indexPath.row < self.venues.count) {
//        return [self venueCellForIndexPath:indexPath];
//    } else {
//        if (isLoading) {
//            return [self loadingCellWithSpinner];
//        } else {
//            return [self loadingCell];
//        }
//        
//    }

}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == [self.venues count]) {
//        currentPage++;
//        [self showSpinnerOnLoadingCell];
//        [self fetchVenuesForMapView];
//        return nil;
//    }
//    return indexPath;
//}


//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//    [self performSegueWithIdentifier:@"venueDetailModal" sender:self];
//}

@end
