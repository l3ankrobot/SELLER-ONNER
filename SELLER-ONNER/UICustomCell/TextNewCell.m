//
//  CustomNewCell.m
//  7Peaks_Project
//
//  Created by Bank on 7/8/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import "TextNewCell.h"

@implementation TextNewCell

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    self.contentView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    self.quoteLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.quoteLabel.frame);
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
}

@end
