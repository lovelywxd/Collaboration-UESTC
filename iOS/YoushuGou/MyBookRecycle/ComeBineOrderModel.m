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
        self.bookIsbnList = nil;
    }
    return self;
}
@end
