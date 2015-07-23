//
//  ViewController.h
//  DynamicTableViewCellHeight
//
//  Created by Khoa Pham on 11/23/14.
//  Copyright (c) 2014 Fantageek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UICustomViewController<UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>
@property (nonatomic, strong) UISearchController *searchController;
- (void)didReceiveData:(id) aObject;

@end

