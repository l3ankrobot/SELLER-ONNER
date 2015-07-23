//
//  EventManager.h
//  SELLER-ONNER
//
//  Created by Bank on 7/20/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventManager : NSValueTransformer
+ (Class)transformedValueClass;
- (id)transformedValue:(id)value;
- (id)reverseTransformedValue:(id)value;
@end
