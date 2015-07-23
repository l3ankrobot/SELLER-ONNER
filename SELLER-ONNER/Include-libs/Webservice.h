//
//  Webservice.h
//  SlidetestProject
//
//  Created by Bank on 6/25/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Webservice : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
    void(^didFailedRequest) (id aResponeMessage);
    void(^didFinishRequest) (id aResponeMessage);
}
@property (nonatomic, retain) NSURLConnection *aConnection;
@property (nonatomic, retain) NSMutableArray *aValueList;
+ (Webservice *)sharedLoader;
- (void)didRequestWithURL:(NSURL *)aURL;
- (void)cancelRequest;
- (void)reload;
- (void)addValue:(NSString *) aValue forKey:(NSString *) aKey;
- (void)didRequestWithURL:(NSURL *)aURL responeFinished:(void(^)(NSDictionary *aDict))aBlockFinish responeFailed:(void(^)(NSDictionary *aDict))aBlockFail;
@end
