//
//  ViewController.m
//  DynamicTableViewCellHeight
//
//  Created by Khoa Pham on 11/23/14.
//  Copyright (c) 2014 Fantageek. All rights reserved.
//

#import "FeedViewController.h"
#import "QuoteTableViewCell.h"
#import "SWRevealViewController.h"

#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate, PopoverViewDelegate>

@property (weak, nonatomic) IBOutlet CFSSpringTableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) QuoteTableViewCell *prototypeCell;
@property (nonatomic, strong) IBOutlet UIView *vOptionControl;
@property (nonatomic, assign) CGPoint lastContentOffset;
@end

@implementation FeedViewController
@synthesize searchController;

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)didSelectOption:(id)sender
{
    UIButton *btn = sender;
    CGPoint aPoint = CGPointMake(btn.frame.origin.x+25, btn.frame.origin.y+25);
    [PopoverView showPopoverAtPoint:aPoint inView:self.vOptionControl withStringArray:@[@"Food",@"Drink",@"Desert",@"Fruit",@"Optional."] delegate:self];
}

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    [popoverView dismiss];
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
//    DLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
 
    self.items = [NSMutableArray array];
    [self initializeTableViewController];
//    [self initializeSearchController];
    
    UIButton *btn_left = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_left.frame = CGRectMake(0, 0, 25, 20);
    [btn_left setBackgroundImage:[UIImage imageNamed:@"menu_btn.png"] forState:UIControlStateNormal];
    [btn_left addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftButton:btn_left];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    /*if (![kAppdelegate isFirstOpenApp]) {
        AppDelegate *app = kAppdelegate;
        app.isFirstOpenApp = YES;
        self.revealViewController.rightViewRevealWidth = self.revealViewController.rearViewRevealWidth = 150.0f;
        [self.revealViewController revealToggleAnimated:NO];
    }*/
    
    
    [self didShowLoadingWithTitle:@"Loading..." showActivity:YES];
    Webservice *aRequest = [Webservice sharedLoader];
    [aRequest didRequestWithURL:[NSURL URLWithString:API] responeFinished:^(NSDictionary *aDict) {
        DLog(@"--->%@",aDict);
        [self dismissLoading];
        self.title = (self.title)? self.title:@"FOTT FEED";
        self.navigationController.navigationBar.topItem.title = (self.navigationController.navigationBar.topItem.title)? self.navigationController.navigationBar.topItem.title:@"FOTT FEED";
        NSArray *aContent = (NSArray *)[aDict objectForKey:@"content"];
        if (!aDict) {
            [self.items removeAllObjects];
            [self.items addObjectsFromArray:[[CoredataManager sharedDatamanager] getDataListWithObjectNamed:@"News" sortObject:[NSArray arrayWithObjects:@"id", nil] ascending:NO]];
            [self.tableView reloadData];
            return;
        }
        
        for (NSDictionary *data in aContent){
            News *aNew = (News *)[[CoredataManager sharedDatamanager] getIntialForKey:@"News" withObject:[[data objectForKey:@"id"] stringValue]];
            aNew.id = [data objectForKey:@"id"];
            aNew.title = [data objectForKey:@"title"];
            aNew.ingress = [[[data objectForKey:@"ingress"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
            aNew.image = [data objectForKey:@"image"];
            aNew.created = [data objectForKey:@"created"];
            aNew.changed = [data objectForKey:@"changed"];
            aNew.date = [data objectForKey:@"dateTime"];
            
            NSArray *contentList = [data objectForKey:@"content"];
            for (NSDictionary *contentData in contentList){
                Content *aNewContent = (Content *)[[CoredataManager sharedDatamanager] getIntialForKey:@"Content" withObject:[[data objectForKey:@"id"] stringValue]];
                aNewContent.id = [data objectForKey:@"id"];
                aNewContent.desc = [contentData objectForKey:@"description"];
                aNewContent.subject = [contentData objectForKey:@"subject"];
                aNewContent.type = [contentData objectForKey:@"type"];
                aNew.contents = aNewContent;
            }
            [[CoredataManager sharedDatamanager] didUpdateDataWithObject:aNew];
        }
        
        [self.items removeAllObjects];
        [self.items addObjectsFromArray:[[CoredataManager sharedDatamanager] getDataListWithObjectNamed:@"News" sortObject:[NSArray arrayWithObjects:@"id", nil] ascending:NO]];
        self.maxOfData = self.items.count;
        [self.tableView reloadData];
        
        
    } responeFailed:^(NSDictionary *aDict) {
        DLog(@"--->%@",aDict);
        [self dismissLoading];
        self.title = (self.title)? self.title:@"FOTT FEED";
        [self.items removeAllObjects];
        [self.items addObjectsFromArray:[[CoredataManager sharedDatamanager] getDataListWithObjectNamed:@"News" sortObject:[NSArray arrayWithObjects:@"id", nil] ascending:NO]];
        [self.tableView reloadData];
        
        UIAlertView *vAlert = [[UIAlertView alloc] initWithTitle:error_message
                                                         message:error_desc
                                                        delegate:self
                                               cancelButtonTitle:input_close
                                               otherButtonTitles: nil];
        [vAlert show];
    }];
   
//    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup
- (void)initializeTableViewController
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)initializeSearchController
{
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.frame = CGRectMake(0, 0, 320, 44);
    
    [[UISearchBar appearance] setBarTintColor:[UIColor grayColor]];
    [[UISearchBar appearance] setTranslucent:NO];
    
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)didReceiveData:(id) aObject
{
    self.title = [aObject objectForKey:@"title"];
    self.navigationController.navigationBar.topItem.title = self.title;
}
#pragma mark - PrototypeCell
- (QuoteTableViewCell *)prototypeCell
{
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuoteTableViewCell class])];
    }

    return _prototypeCell;
}

#pragma mark - Configure
- (void)configureCell:(QuoteTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *aData = (News *)[self.items objectAtIndex:indexPath.row];
    NSString *url = [aData.image stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    cell.numberLabel.text = [self didCheckDateWithString:aData.date];
    cell.quoteLabel.text = aData.ingress;
    cell.titleLabel.text = aData.title;
    [cell.image setImageURL:[NSURL URLWithString:url]];
}

#pragma mark - UITableViewDataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.items count];
    
    if ([self.items count] < self.maxOfData+1 && !self.searchController.isActive && self.items.count > 0) {
        count += 1;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MoreCellId = @"moreCell";
    
    NSInteger rowCount = [self.items count];
    
    if (indexPath.row == rowCount) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MoreCellId];
            cell.backgroundColor = [UIColor whiteColor];
            cell.alpha = 0.5f;
            
            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityView.tag = 999;
            activityView.hidesWhenStopped = YES;
            activityView.center = CGPointMake(cell.bounds.size.width / 4.0f, cell.bounds.size.height / 2.0f);
            activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            [cell addSubview:activityView];
            [activityView startAnimating];
            
            
            UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
            lb_title.center = CGPointMake(cell.bounds.size.width / 2.0f, cell.bounds.size.height / 2.0f);
            lb_title.tag = 9999;
            [cell addSubview:lb_title];
        }
        
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[cell viewWithTag:999];
        if (!activityView.isAnimating) {
            [activityView startAnimating];
        }
        
        UILabel *lb_title = (UILabel *)[cell viewWithTag:9999];
        lb_title.text = @"Get more contents...";
    
        return cell;
    }
    QuoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuoteTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    [self configureCell:cell forRowAtIndexPath:indexPath];

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }

    //self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));

    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];

    [self.prototypeCell updateConstraintsIfNeeded];
    [self.prototypeCell layoutIfNeeded];

    return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.items count]) {
        UIAlertView *vAlert = [[UIAlertView alloc] initWithTitle:error_message
                                                         message:@"Request load more contents"
                                                        delegate:self
                                               cancelButtonTitle:input_close
                                               otherButtonTitles: nil];
        [vAlert show];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    } else {
        News *aData = (News *)[self.items objectAtIndex:indexPath.row];
        
        DetailViewController *vDetail = [DetailViewController initialDetailViewController];
        vDetail.aData = aData;
        vDetail.title = aData.title;
        [self.navigationController pushViewController:vDetail animated:YES];
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView prepareCellForShow:cell];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset.x = scrollView.contentOffset.x;
    _lastContentOffset.y = scrollView.contentOffset.y;
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
 {
    if (_lastContentOffset.x < (int)scrollView.contentOffset.x) {
        // moved right
        NSLog(@"right");
    }else if (_lastContentOffset.x > (int)scrollView.contentOffset.x) {
        // moved left
        NSLog(@"left");
    }else if (_lastContentOffset.y<(int)scrollView.contentOffset.y){//Up
        self.vOptionControl.hidden = YES;
    }else if (_lastContentOffset.y>(int)scrollView.contentOffset.y){//Down
        self.vOptionControl.hidden = NO;
    }
    
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.vOptionControl.hidden = (velocity.y > 0)? YES:NO;
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    
     NSString *searchText = [self.searchController.searchBar text];
     NSArray *filtered  = nil;
     NSArray *allItems = [[CoredataManager sharedDatamanager] getDataListWithObjectNamed:@"News" sortObject:[NSArray arrayWithObjects:@"id", nil] ascending:NO];
     [self.items removeAllObjects];
     
     if ([searchText length] > 0){
         filtered = [[CoredataManager sharedDatamanager] sortDataWithString:searchText fromArray:allItems searchForKey:@"title"];
     }else{
         filtered  = allItems;
     }
     [self.items addObjectsFromArray:filtered];
     [self.tableView reloadData];
     [((UITableViewController *)self.searchController.searchResultsController).tableView reloadData];
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSArray *allItems = [[CoredataManager sharedDatamanager] getDataListWithObjectNamed:@"News" sortObject:[NSArray arrayWithObjects:@"id", nil] ascending:NO];
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:allItems];
    [self.tableView reloadData];
}



@end
