//
//  UserOrderDetail.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
@interface UserOrderDetail : NSObject<NSCopying>
@property (nonatomic ,copy) UserInfo *userInfo;
// Good数组
@property (nonatomic ,copy) NSArray *bookList;

- (instancetype)initUser:(UserInfo*)info withOrderList:(NSArray*)orderList;
- (instancetype)initWithDictionary:(NSDictionary*)dic;
@end
