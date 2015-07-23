//
//  ImageLoader.h
//  SlidetestProject
//
//  Created by Bank on 6/25/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageLoader : UIImageView {
    
}
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) BOOL showActivityIndicator;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorStyle;

- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;
- (void)setImageURL:(NSURL *)imageURL;
@end