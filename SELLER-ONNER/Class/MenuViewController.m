//
//  MenuViewController.m
//  7Peaks_Project
//
//  Created by Bank on 7/7/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "FeedViewController.h"

@interface MenuViewController ()
@property (nonatomic, retain) NSMutableArray *aObjects;
@property (nonatomic, assign) NSInteger aIndexOfSelect;
@property (nonatomic, retain) IBOutlet UIImageView *img_logo;

@end

@implementation MenuViewController {
    
    IBOutlet UITableView *vTableMenu;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.aIndexOfSelect = 0;
    self.aObjects = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Menu_list" ofType: @"plist"];
    [self.aObjects addObjectsFromArray:[NSArray arrayWithContentsOfFile:path]];
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
    return [self.aObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *lb_title = (UILabel *)[cell viewWithTag:111];
    lb_title.text = [[self.aObjects objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    ImageLoader *img_icon = (ImageLoader *)[cell viewWithTag:222];
    img_icon.image = [UIImage imageNamed:[[self.aObjects objectAtIndex:indexPath.row] objectForKey:@"image"]];
//    
//    [img_icon setImageURL:[NSURL URLWithString:[[self.aObjects objectAtIndex:indexPath.row] objectForKey:@"image"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [self performSegueWithIdentifier:@"Present" sender:cell];
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [vTableMenu indexPathForSelectedRow];
    if (self.aIndexOfSelect == indexPath.row) {
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        return;
    }
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            self.aIndexOfSelect = indexPath.row;
            if ([segue.identifier isEqualToString:@"Present"]) {
                
                FeedViewController *mainView = (FeedViewController*)segue.destinationViewController;
                [mainView didReceiveData:[self.aObjects objectAtIndex:indexPath.row]];
            }
        };
    }
    
}

@end
