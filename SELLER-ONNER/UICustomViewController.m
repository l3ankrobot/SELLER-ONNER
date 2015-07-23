//
//  UICustomViewController.m
//  SlidetestProject
//
//  Created by Bank on 6/23/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import "UICustomViewController.h"

@interface UICustomViewController ()<UIGestureRecognizerDelegate, PopoverViewDelegate>

@end

@implementation UICustomViewController
@synthesize vAlert = _vAlert;
@synthesize vProgress = _vProgress;
@synthesize disableDetectTouch;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize maxOfData;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.managedObjectContext = [kAppdelegate managedObjectContext];
        self.persistentStoreCoordinator = [kAppdelegate persistentStoreCoordinator];
    }
    return self;
}

#pragma mark - PopoverViewDelegate Methods
- (PopoverView *)initializePopoverWithView:(UIView *) aView setPoint:(CGPoint) aPoint showInview:(UIView *) aPresentView
{
    PopoverView *vPopView = [PopoverView showPopoverAtPoint:aPoint inView:aPresentView withTitle:nil withContentView:aView delegate:self];
    return vPopView;
}

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    DLog(@"%s item:%ld", __PRETTY_FUNCTION__, (long)index);
    /*
     // Figure out which string was selected, store in "string"
     NSString *string = [kStringArray objectAtIndex:index];
     
     // Show a success image, with the string from the array
     [popoverView showImage:[UIImage imageNamed:@"success"] withMessage:string];
     [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];*/
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    DLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)didShowLoadingWithTitle:(NSString *) aTitle showActivity:(BOOL) aBool
{
    self.vAlert = [[UIAlertView alloc] initWithTitle:aTitle message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    CGRect aFrame = indicator.frame;
    aFrame.origin.x = 128;
    indicator.frame = aFrame;
    UIView *vActivity = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    vActivity.backgroundColor = [UIColor clearColor];
    [vActivity addSubview:indicator];
    [self.vAlert setValue:vActivity forKey:@"accessoryView"];
    
    [self.vAlert show];
    
}

- (void)setUpBackButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 35, 25);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didSelectLeft:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *vLeft = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -12;// it was -6 in iOS 6
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, vLeft, nil] animated:NO];
    
}

- (void)setLeftButton:(UIButton*) btnLeft
{
    if (!btnLeft) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = nil;
        return;
    }
    [btnLeft addTarget:self action:@selector(didSelectLeft:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -7;
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, vLeft, nil] animated:NO];
    
}

- (void)setRightButton:(UIButton*) btnRight
{
    if (!btnRight) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = nil;
        return;
    }
    [btnRight addTarget:self action:@selector(didSelectRight:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -7;
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, vRight, nil] animated:NO];
}


- (void)didSelectRight:(id)sender;
{
    
}

- (void)didSelectLeft:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didHidenBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)didShowBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)didShowLoadingWithTitle:(NSString *) aTitle showProgress:(BOOL) aBool
{
    self.vAlert = [[UIAlertView alloc] initWithTitle:aTitle message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    self.vProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    
    CGRect aFrame = indicator.frame;
    aFrame.origin.x = 128;
    indicator.frame = aFrame;
    UIView *vActivity = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    vActivity.backgroundColor = [UIColor clearColor];
    [vActivity addSubview:indicator];
    [self.vAlert setValue:vActivity forKey:@"accessoryView"];
    [self.vAlert show];
    
}
- (void)dismissLoading
{
    [self.vAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTabScreen:)];
    tapper.delegate = self;
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
 
    self.navigationItem.hidesBackButton = YES;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (float)heightOfCell:(NSString *)string widthOfCell:(CGFloat) aWidth fontSize:(CGFloat) aSize
{
    
    CGSize maximumSize = CGSizeMake(aWidth, MAXFLOAT);
    UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:aSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:labelFont,
                              NSFontAttributeName,
                              paragraphStyle,
                              NSParagraphStyleAttributeName,
                              nil];
    CGRect lblRect = [string boundingRectWithSize:maximumSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attrDict
                                          context:nil];
    
    return lblRect.size.height;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]||
        [touch.view isKindOfClass:[UITextView class]]||
        [touch.view isKindOfClass:[UITextField class]])
    {
        // we touched our control surface
        return NO; // ignore the touch
    }
    if(!self.disableDetectTouch)
    {
        [self.view endEditing:YES];
    }
    [self didTabScreen:(UITapGestureRecognizer*)gestureRecognizer];
    return YES; // handle the touch
}

- (void)didTabScreen:(UITapGestureRecognizer *) sender
{
    
    
}

- (NSString *)didCheckDateWithString:(NSString *)strDate
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSDate* date = [dateFormat dateFromString:strDate];
    
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setDateFormat:@"dd MMMM, HH:mm"];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    return ([today isEqualToDate:otherDate])? @"Today":[dateFormat stringFromDate:date];;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
