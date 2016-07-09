//
//  ValidCombineOrder.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "ValidCombineOrder.h"

@implementation ValidCombineOrder

- (instancetype)initWihtDictionary:(NSDictionary*)dic {
    self = [super init];
    if (self) {
//        ComeBineOrderModel *comBineOrderInfo = [[ComeBineOrderModel alloc] initCombineOrder:[dic objectForKey:@"combineOrderID"] withUsrOrder:[dic objectForKey:@"submitOrderID"] status:[dic objectForKey:@"currentStatus"] promotion:[dic objectForKey:@"promotionID"] submitOderPirce:[dic objectForKey:@"submitOrderPrice"] combineOrderPrice:[dic objectForKey:@"comineOrderPrice"] submitNeedPrice:[dic objectForKey:@"submitNeedPrice"] combineNeedPrice:[dic objectForKey:@"combineNeedPrice"] combineTime:[dic objectForKey:@"combineTime"] combineTimeLimited:nil];
//        ;
//        self.combineOrderInfo = comBineOrderInfo;
        self.combineOrderID = [dic objectForKey:@"combineOrderID"];
        self.currentStatus = [dic objectForKey:@"currentStatus"];
        NSDictionary *userList = [dic objectForKey:@"userlist"];
        self.gameLeader = [[UserOrderDetail alloc] initWithDictionary:[userList objectForKey:@"gameLeader"]];
        
        NSArray *rawArr = [userList objectForKey:@"gameMember"];
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (id obj in rawArr) {
            UserOrderDetail *uOderDetail = [[UserOrderDetail alloc] initWithDictionary:obj];
            [result addObject:uOderDetail];
        }
     
        self.members = [result copy];

        
    }
    return self;
}
@end
