//
//  CREListViewController.m
//  Crema
//
//  Created by Jeff Wells on 2/28/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREListViewController.h"
#import "CREVenue.h"
#import "CREVenueDetailViewController.h"


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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"venueDetailModal"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        CREVenueDetailViewController *destinationController = [segue destinationViewController];
        CREVenue *venue = [CREVenueCollection venues][indexPath.row];
        destinationController.venue = venue;
        destinationController.index = indexPath;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"venueCell";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CREVenue *venue;
    
    venue = (CREVenue*) [[CREVenueCollection venues] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = venue.name;
    [cell.detailTextLabel setText:venue.addressString];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"venueDetailModal" sender:self];
}

@end
