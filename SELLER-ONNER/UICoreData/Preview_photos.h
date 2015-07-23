//
//  Preview_photos.h
//  SELLER-ONNER
//
//  Created by Bank on 7/20/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Preview_photos : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSManagedObject *preview;

@end
