//
//  ComeBineOrderModel.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "ComeBineOrderModel.h"

@implementation ComeBineOrderModel
- (instancetype)initWihtDictionary:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        self.promotionID = [dic objectForKey:@"promotionID"];
        self.currentStatus = [dic objectForKey:@"currentStatus"];
        self.combineOrderID = [dic objectForKey:@"combineOrderID"];
        self.submitOrderID = [dic objectForKey:@"submitOrderID"];
        self.submitOrderPrice = [dic objectForKey:@"submitOrderPrice"];
        self.comineOrderPrice = [dic objectForKey:@"comineOrderPrice"];
        self.combineNeedPrice = [dic objectForKey:@"combineNeedPrice"];
        self.submitNeedPrice = [dic objectForKey:@"submitNeedPrice"];
        self.combineTime = [dic objectForKey:@"combineTime"];
        self.combineTimeLimited = [dic objectForKey:@"combineTimeLimited"];
    }
    return self;
}

- (instancetype)initCombineOrder:(NSString*)CoID withUsrOrder:(NSString*)UoID status:(NSNumber*)state promotion:(NSString*)proID submitOderPirce:(NSString*)SoPrice combineOrderPrice:(NSString*)CoPrice submitNeedPrice:(NSString*)SnPrice combineNeedPrice:(NSString*)CnPrice combineTime:(NSString*)cTime combineTimeLimited:(NSString*)CtlTime {
    self = [super init];
    if (self) {
        self.promotionID = proID;
        self.currentStatus = state;
        self.combineOrderID = CoID;
        self.submitOrderID = UoID;
        self.submitOrderPrice = SoPrice;
        self.comineOrderPrice = CoPrice;
        self.combineNeedPrice = CnPrice;
        self.submitNeedPrice = SnPrice;
        self.combineTime = cTime;
        self.combineTimeLimited = CtlTime;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    ComeBineOrderModel *item = [[[self class] allocWithZone:zone] init];
    item.promotionID = self.promotionID;
    item.currentStatus = self.currentStatus;
    item.combineOrderID = self.combineOrderID;
    item.submitOrderID = self.submitOrderID;
    item.submitOrderPrice = self.submitOrderPrice;
    item.comineOrderPrice = self.comineOrderPrice;
    item.combineNeedPrice = self.combineNeedPrice;
    item.submitNeedPrice = self.submitNeedPrice;
    item.combineTime = self.combineTime;
    item.combineTimeLimited = self.combineTimeLimited;
    return  item;
}
@end
