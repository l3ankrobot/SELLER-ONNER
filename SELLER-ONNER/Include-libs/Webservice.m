//
//  Webservice.m
//  SlidetestProject
//
//  Created by Bank on 6/25/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import "Webservice.h"

@interface Webservice ()
@property (nonatomic,copy) NSURL *aURL_Request;
@end

@implementation Webservice
@synthesize aConnection;
@synthesize aValueList;

+ (Webservice *)sharedLoader
{
    static Webservice *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [(Webservice *)[self alloc] init];
    }
    return sharedInstance;
}

- (void)didRequestWithURL:(NSURL *)aURL
          responeFinished:(void(^)(NSDictionary *aDict))aBlockFinish
            responeFailed:(void(^)(NSDictionary *aDict))aBlockFail
{
    self.aURL_Request = nil;
    self.aURL_Request = [aURL copy];
    
    didFinishRequest = nil;
    didFinishRequest = [aBlockFinish copy];
    
    didFailedRequest = nil;
    didFailedRequest = [aBlockFail copy];
    
    [self didRequestWithURL:aURL];
    
}

- (void)addValue:(NSString *) aValue forKey:(NSString *) aKey
{
    @autoreleasepool {
        if (!self.aValueList) {
            self.aValueList  = [[NSMutableArray alloc] init];
        }
        NSDictionary *aPost = [NSDictionary dictionaryWithObjectsAndKeys:aValue,@"value",aKey,@"key", nil];
        if (self.aValueList) {
            [self.aValueList addObject:aPost];
        }
    }
    
}

- (NSData *)httpBodyForParamsDictionary:(NSDictionary *)paramDictionary
{
    NSMutableArray *parameterArray = [NSMutableArray array];
    
    [paramDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", key, [obj stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        [parameterArray addObject:param];
    }];
    
    NSString *string = [parameterArray componentsJoinedByString:@"&"];
    
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)didRequestWithURL:(NSURL *)aURL
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aURL];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *aData = [NSMutableData data];
    for (NSDictionary *params in self.aValueList){
        [aData appendData:[self httpBodyForParamsDictionary:params]];
    }
    [request setHTTPBody:aData];
    
    self.aConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)reload
{
    [self.aConnection cancel];
    [self didRequestWithURL:self.aURL_Request];
}

- (void)cancelRequest
{
    [self.aConnection cancel];
}

#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
   
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error];
    
    if (didFinishRequest) {
        didFinishRequest(json);
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
 
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (didFailedRequest) {
        didFailedRequest(error);
    }
}
@end
