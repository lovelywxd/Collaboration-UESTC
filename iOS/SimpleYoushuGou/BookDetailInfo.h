//
//  BookDetailInfo.h
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/26.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookBaseInfo.h"
#import "BookSaleInfo.h"

@interface BookDetailInfo : NSObject
@property (nonatomic,strong) BookBaseInfo* baseInfo;//书籍基本信息
@property (nonatomic,strong) BookSaleInfo* saleInfo;//书籍售卖信息
@end
