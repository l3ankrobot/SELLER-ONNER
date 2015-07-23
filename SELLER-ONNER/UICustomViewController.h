//
//  UICustomViewController.h
//  SlidetestProject
//
//  Created by Bank on 6/23/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "Content.h"

@class PopoverView;

@interface UICustomViewController : UIViewController<UIAlertViewDelegate>
@property (nonatomic, retain) UIAlertView *vAlert;
@property (nonatomic, retain) UIProgressView *vProgress;
@property (nonatomic, assign) BOOL disableDetectTouch;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, assign) NSInteger maxOfData;
- (float)heightOfCell:(NSString *)string widthOfCell:(CGFloat) aWidth fontSize:(CGFloat) aSize;
- (PopoverView *)initializePopoverWithView:(UIView *) aView setPoint:(CGPoint) aPoint showInview:(UIView *) aPresentView;
- (NSString *)didCheckDateWithString:(NSString *)strDate;

- (void)didShowLoadingWithTitle:(NSString *) aTitle showActivity:(BOOL) aBool;
- (void)didShowLoadingWithTitle:(NSString *) aTitle showProgress:(BOOL) aBool;
- (void)dismissLoading;
- (void)didTabScreen:(UITapGestureRecognizer *) sender;
- (void)setUpBackButton;
- (void)setLeftButton:(UIButton*) btnLeft;
- (void)setRightButton:(UIButton*) btnRight;
- (void)didSelectRight:(id)sender;
- (void)didSelectLeft:(id)sender;
-(void)didHidenBar;
-(void)didShowBar;
@end
