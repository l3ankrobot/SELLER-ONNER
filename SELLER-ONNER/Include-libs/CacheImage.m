//
//  CacheImage.m
//  7Peaks_Project
//
//  Created by Bank on 7/8/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import "CacheImage.h"

static CacheImage *sharedInstance;

@interface CacheImage ()
@property (nonatomic, strong) NSCache *imageCache;
@end

@implementation CacheImage

+ (CacheImage*)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CacheImage alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)setCacheImage:(UIImage*)image forKey:(NSString*)key {
    [self.imageCache setObject:image forKey:key];
}

- (UIImage*)getCachedImageForKey:(NSString*)key {
    return [self.imageCache objectForKey:key];
}

@end
