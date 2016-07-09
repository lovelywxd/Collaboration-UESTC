//
//  ValidCombineOrder.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComeBineOrderModel.h"
#import "UserOrderDetail.h"


@interface ValidCombineOrder : NSObject
//@property (nonatomic ,copy) ComeBineOrderModel* combineOrderInfo;
@property (nonatomic ,copy) NSString *combineOrderID;
@property (nonatomic ,copy) NSString *currentStatus;
@property (nonatomic ,copy) UserOrderDetail* gameLeader;
//UserOrderDetail数组，存有其他成员的订单相信息
@property (nonatomic ,copy) NSArray* members;
- (instancetype)initWihtDictionary:(NSDictionary*)dic;
@end
