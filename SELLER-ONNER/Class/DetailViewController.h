//
//  DetailViewController.h
//  7Peaks_Project
//
//  Created by Bank on 7/8/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import "UICustomViewController.h"

@interface DetailViewController : UICustomViewController
+ (DetailViewController*)initialDetailViewController;

@property (nonatomic, retain) News *aData;
@end
