//
//  Content.h
//  SELLER-ONNER
//
//  Created by Bank on 7/20/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Content : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDecimalNumber * id;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * type;

@end
