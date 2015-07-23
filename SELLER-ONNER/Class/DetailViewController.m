//
//  DetailViewController.m
//  7Peaks_Project
//
//  Created by Bank on 7/8/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSString *superTitle;
}
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) QuoteTableViewCell *prototypeCell;
@property (nonatomic, strong) TextNewCell *prototypeTextCell;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *aObjects;

@end

@implementation DetailViewController
@synthesize aData;

+ (DetailViewController*)initialDetailViewController
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *vService = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    vService.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return vService;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.topItem.title = superTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    superTitle = self.navigationController.navigationBar.topItem.title;
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.hidesBackButton = NO;

    self.tableView.backgroundColor = [UIColor clearColor];
    self.aObjects = [NSMutableArray array];
    
    DLog(@"-->%@",self.aData.datacontent);
    [self.aObjects addObject:self.aData.contents];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PrototypeCell
- (QuoteTableViewCell *)prototypeCell
{
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuoteTableViewCell class])];
    }
    return _prototypeCell;
}

- (TextNewCell *)prototypeTextCell
{
    if (!_prototypeTextCell) {
        _prototypeTextCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextNewCell class])];
    }
    return _prototypeTextCell;
}

#pragma mark - Configure
- (void)configureCell:(QuoteTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url = [self.aData.image stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    cell.numberLabel.text = [self didCheckDateWithString:self.aData.date];
    cell.quoteLabel.text = self.aData.ingress;
    cell.titleLabel.text = self.aData.title;
    [cell.image setImageURL:[NSURL URLWithString:url]];
}

- (void)configureContentCell:(TextNewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Content *data_content = [self.aObjects objectAtIndex:indexPath.row];
    cell.numberLabel.text = data_content.type;
    cell.quoteLabel.text = [data_content.subject stringByAppendingString:data_content.desc];
}

#pragma mark - UITableViewDataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != 0) {
        return self.aObjects.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        QuoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuoteTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
    }

    TextNewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextNewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureContentCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section !=0)? 20.0f:0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setAlpha:0.0F];
    return view;
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
    if (indexPath.section == 0) {
        [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
        [self.prototypeCell updateConstraintsIfNeeded];
        [self.prototypeCell layoutIfNeeded];
        
        return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    
    [self configureContentCell:self.prototypeTextCell forRowAtIndexPath:indexPath];
    [self.prototypeTextCell updateConstraintsIfNeeded];
    [self.prototypeTextCell layoutIfNeeded];
    
    return [self.prototypeTextCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.isEditing)
    {

    }
}

@end
