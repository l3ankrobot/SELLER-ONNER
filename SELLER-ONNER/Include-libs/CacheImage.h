//
//  CacheImage.h
//  7Peaks_Project
//
//  Created by Bank on 7/8/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheImage : NSObject

+ (CacheImage*)sharedInstance;

- (void)setCacheImage:(UIImage*)image forKey:(NSString*)key;
- (UIImage*)getCachedImageForKey:(NSString*)key;

@end
