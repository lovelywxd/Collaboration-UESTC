//
//  PriceComparisonItem.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/30.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceComparisonItem : NSObject
@property (nonatomic, copy) NSString *bookSaler;//电商名字，服务器返回的是电商对应的图片的名字，如beifa.png，jd.png
@property (nonatomic, copy) NSString *bookCurrentPrice;//书籍当前价格
@property (nonatomic, copy) NSString *bookLink;//电商网站上该书的链接


@end
