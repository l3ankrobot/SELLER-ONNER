//
//  ImageLoader.m
//  SlidetestProject
//
//  Created by Bank on 6/25/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import "ImageLoader.h"
#import "CacheImage.h"

@implementation ImageLoader
{
    Reachability *reachability;
}
@synthesize activityView;
@synthesize activityIndicatorStyle = _activityIndicatorStyle;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setIntial];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setIntial];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setIntial];
    }
    return self;
}

- (void)setIntial
{
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    [self updateInterfaceWithReachability:reachability];
    self.showActivityIndicator = (self.image == nil);
    self.activityIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
}

- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
    _activityIndicatorStyle = style;
    [self.activityView removeFromSuperview];
    self.activityView = nil;
}

- (void)setImageURL:(NSURL *)imageURL
{
    [self downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
        
    }];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    if (self.activityView == nil)
    {
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorStyle];
        self.activityView.hidesWhenStopped = YES;
        self.activityView.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
        self.activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.activityView];
    }
    [self.activityView startAnimating];
    
    UIImage *image = [[CacheImage sharedInstance] getCachedImageForKey:[url absoluteString]];
    if (image) {
        self.image = image;
        [self.activityView stopAnimating];
        [self.activityView removeFromSuperview];
        self.activityView = nil;
//        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
//        DLog(@"-->%@",resourcePath);
        completionBlock(YES,image);
    }else{
        self.image = [UIImage imageNamed:@"icon_180.png"];
        NSMutableURLRequest *request = nil;
        if (reachability.isReachable){
            request = [NSMutableURLRequest requestWithURL:url];
        }else{
            request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
        }
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if ( !error )
                                   {
                                       UIImage *image = [[UIImage alloc] initWithData:data];
                                       self.image = image;
                                       [self.activityView stopAnimating];
                                       [self.activityView removeFromSuperview];
                                       self.activityView = nil;
                                       [[CacheImage sharedInstance] setCacheImage:image forKey:[url absoluteString]];
                                       completionBlock(YES,image);
                                   } else{
                                       completionBlock(NO,nil);
                                   }
                               }];
        
        
    }
    
    
}

@end
