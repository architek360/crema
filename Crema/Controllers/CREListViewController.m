//
//  CREListViewController.m
//  Crema
//
//  Created by Jeff Wells on 2/28/14.
//  Copyright (c) 2014 Jeff Wells. All rights reserved.
//

#import "CREListViewController.h"


@interface CREListViewController ()

@property (nonatomic) BOOL isLoading;

@end

@implementation CREListViewController
@synthesize isLoading;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISwipeGestureRecognizer* tableCellSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
    tableCellSwipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:tableCellSwipeLeft];
    UISwipeGestureRecognizer* tableCellSwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightFrom:)];
    tableCellSwipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:tableCellSwipeRight];
    
    [self.tableView setSeparatorColor:[UIColor whiteColor]];

    [self.tableView reloadData];
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
    
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 320, 205)];
    
    if (!venue.imageIndex) {
        venue.imageIndex = 0;
    }

    
    NSURL *url = [NSURL URLWithString:[venue.photoUrls objectAtIndex:venue.imageIndex]];
    [imgview setImageWithURL:url];
    
    [cell setBackgroundView:imgview];
    
    return cell;

}

- (void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer {

    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];

    CREVenue *venue = (CREVenue*) [[CREVenueCollection venues] objectAtIndex:swipedIndexPath.row];
    
    [venue adjustImageIndex:UISwipeGestureRecognizerDirectionLeft];
    
    [self.tableView reloadRowsAtIndexPaths:@[swipedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {
    
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    
    CREVenue *venue = (CREVenue*) [[CREVenueCollection venues] objectAtIndex:swipedIndexPath.row];
    
    [venue adjustImageIndex:UISwipeGestureRecognizerDirectionRight];
    
    [self.tableView reloadRowsAtIndexPaths:@[swipedIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 205.0;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//}
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
    
    [self performSegueWithIdentifier:@"venueDetailModal" sender:self];
}

@end
