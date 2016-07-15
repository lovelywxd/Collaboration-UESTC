//
//  bookEmergeInSaler.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/15.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bookEmergeInSaler : NSObject
@property (nonatomic ,copy) NSString *bookISBN;
//PriceComparisonItem数组
@property (nonatomic ,copy) NSArray *priceList;
- (instancetype)initWithDic:(NSDictionary*)dic;
@end
