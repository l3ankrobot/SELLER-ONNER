//
//  UserInformation.h
//  SELLER-ONNER
//
//  Created by Bank on 7/20/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Preview_photos;

@interface UserInformation : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * cover_url;
@property (nonatomic, retain) NSData * photos;
@property (nonatomic, retain) Preview_photos *preview;

@end
