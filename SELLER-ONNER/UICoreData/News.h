//
//  News.h
//  SELLER-ONNER
//
//  Created by Bank on 7/21/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content;

@interface News : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * changed;
@property (nonatomic, retain) NSDecimalNumber * created;
@property (nonatomic, retain) id  datacontent;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSDecimalNumber * id;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * ingress;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Content *contents;

@end
