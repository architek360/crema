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

    NSLog(@"ImageIndex RELOAD: %lu,", (unsigned long) venue.imageIndex);
    
    NSURL *url = [NSURL URLWithString:[venue.photoUrls objectAtIndex:venue.imageIndex]];
    [imgview setImageWithURL:url];
    
    [cell setBackgroundView:imgview];
    
    return cell;

}

- (void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer {
//    NSLog(@"Swipe Left");
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];

    CREVenue *venue = (CREVenue*) [[CREVenueCollection venues] objectAtIndex:swipedIndexPath.row];
    
    NSLog(@"ImageIndex SWIPE-LEFT BEFORE: %lu,", (unsigned long) venue.imageIndex);
    
    if (venue.imageIndex + 1 < [venue.photoUrls count]) {
        venue.imageIndex++;
    } else {
        venue.imageIndex = 0;
    }
    NSLog(@"ImageIndex SWIPE-LEFT AFTER: %lu,", (unsigned long) venue.imageIndex);
    
    [self.tableView reloadRowsAtIndexPaths:@[swipedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {
    NSLog(@"Swipe Right");
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    
    CREVenue *venue = (CREVenue*) [[CREVenueCollection venues] objectAtIndex:swipedIndexPath.row];
    
    NSLog(@"ImageIndex SWIPE-RIGHT BEFORE: %lu,", (unsigned long) venue.imageIndex);
    
    if (venue.imageIndex == 0) {
        venue.imageIndex = [venue.photoUrls count] - 1;
    } else {
        venue.imageIndex--;
    }
    NSLog(@"ImageIndex SWIPE-RIGHT AFTER: %lu,", (unsigned long) venue.imageIndex);
    
    [self.tableView reloadRowsAtIndexPaths:@[swipedIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 205.0;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"venueDetailModal" sender:self];
}

@end
