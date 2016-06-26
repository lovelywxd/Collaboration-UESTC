//
//  BookSaleInfo.h
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/26.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PromotionCell.h"

@interface BookSaleInfo : NSObject
@property (nonatomic,copy) NSString* boolLink;//书籍在电商网站的链接
@property (nonatomic,assign) CGFloat currentPrice;
@property (nonatomic,assign) CGFloat originalPrice;
@property (nonatomic,assign) NSInteger discount;
@end
