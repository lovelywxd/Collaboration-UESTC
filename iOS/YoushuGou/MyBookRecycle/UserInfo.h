//
//  UserInfo.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodModel.h"

@interface UserInfo : NSObject <NSCopying>
@property (nonatomic ,copy) NSString* username;
@property (nonatomic ,copy) NSString* phone;
@property (nonatomic ,copy) NSString* email;
@property (nonatomic ,copy) NSString* school;

- (instancetype)initWithDic:(NSDictionary*)dic;
@end
