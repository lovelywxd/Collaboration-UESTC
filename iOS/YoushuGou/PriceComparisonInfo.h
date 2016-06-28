//
//  PriceComparisonInfo.h
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/26.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookSaleInfo.h"

@interface PriceComparisonInfo : NSObject
@property (nonatomic,copy) NSString* shopID;//电商ID（采用电商名字？）
@property (nonatomic,strong) BookSaleInfo* saleInfo;//书籍售卖信息


@end
