//
//  promotionSearchListItem.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/1.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface promotionSearchListItem : NSObject
@property (nonatomic, copy) NSString *promotionBookImageLink;//书籍图片链接
@property (nonatomic, copy) NSString *promotionBookDetailLink;//促销图书详情页链接（用于请求图书价格列表时的查询值）
@property (nonatomic, copy) NSString *promotionBookName;//书籍名字
@property (nonatomic, copy) NSString *promotionBookISBN;
@property (nonatomic, copy) NSString *promotionBookPrice;//书籍当前

@end
