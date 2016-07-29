//
//  UserOrderDetail.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "UserOrderDetail.h"
#import "UserInfo.h"
#import "Good.h"

@implementation UserOrderDetail


- (instancetype)initUser:(UserInfo*)info withOrderList:(NSArray*)orderList {
    self = [super init];
    if (self) {
        self.userInfo = info;
        self.bookList = orderList;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        
        UserInfo *info = [[UserInfo alloc] initWithDic:dic];
        self.userInfo = info;
        NSMutableArray *list = [[NSMutableArray alloc] init];
        NSArray *rawList = [dic objectForKey:@"bookList"];
        for (id obj in rawList) {
            Good *good = [[Good alloc] initWithDicNewWay:obj];
            [list addObject:good];
        }
        self.bookList = [list copy];
    }
    
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    UserOrderDetail *item = [[[self class] allocWithZone:zone] init];
    item.userInfo = self.userInfo;
    item.bookList = self.bookList;
    return item;
}
@end
