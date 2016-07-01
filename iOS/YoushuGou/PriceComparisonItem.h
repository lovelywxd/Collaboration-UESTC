//
//  PriceComparisonItem.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/30.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceComparisonItem : NSObject
@property (nonatomic, copy) NSString *bookSaler;//电商名字，服务器返回的是电商图片链接
@property (nonatomic, copy) NSString *bookCurrentPrice;//书籍当前价格
@property (nonatomic, copy) NSString *bookLink;//书籍电商网站链接（原URL是缺书网上的，重定为至电商网站

- (instancetype)initSaler:(NSString*)saler withPrice:(NSString*)price link:(NSString*)aLink;

@end
