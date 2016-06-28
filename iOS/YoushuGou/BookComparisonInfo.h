//
//  BookComparisonInfo.h
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/26.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookBaseInfo.h"
#import "BookComparisonInfo.h"
@interface BookComparisonInfo : NSObject
@property (nonatomic,strong) BookBaseInfo* baseInfo;//书籍基本信息
@property (nonatomic,strong) NSArray* comparisonInfo;//比价信息表。元素为BookComparisonInfo
@end
