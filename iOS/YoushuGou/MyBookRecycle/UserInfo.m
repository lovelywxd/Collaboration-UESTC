//
//  UserInfo.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
- (id)copyWithZone:(NSZone *)zone {
    UserInfo *item = [[[self class] allocWithZone:zone] init];
    item.username = self.username;
    item.phone = self.phone;
    item.email = self.email;
    item.school = self.school;
    return item;
}

- (instancetype)initWithDic:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        self.username = [dic objectForKey:@"userName"];
        self.phone = [dic objectForKey:@"phone"];
        self.email = [dic objectForKey:@"email"];
        self.school = [dic objectForKey:@"school"];
    }
    return self;
}


@end
