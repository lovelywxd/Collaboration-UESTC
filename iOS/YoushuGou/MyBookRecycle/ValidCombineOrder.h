//
//  ValidCombineOrder.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidCombineOrder : NSObject
@property (nonatomic ,copy) NSString* currentStatus;
@property (nonatomic ,copy) NSString* promotionID;
@property (nonatomic ,copy) NSString* combineTime;
@property (nonatomic ,copy) NSString* combineOrderID;
@property (nonatomic ,copy) NSString* submitOrderID;
@property (nonatomic ,copy) NSString* submitOrderPrice;
@property (nonatomic ,copy) NSString* comineOrderPrice;
@property (nonatomic ,copy) NSString* combineNeedPrice;
@property (nonatomic ,copy) NSString* submitNeedPrice;

- (instancetype)initWihtDictionary:(NSDictionary*)dic;
@end
