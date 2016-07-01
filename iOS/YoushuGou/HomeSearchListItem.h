//
//  HomeSearchListItem.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/29.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeSearchListItem : NSObject <NSCopying>
@property (nonatomic, copy) NSString *bookName;//书籍名字
@property (nonatomic, copy) NSString *booSubject;//书籍在豆瓣上的链接, 此内容用于主页搜索是请求头部的查询字段
@property (nonatomic, copy) NSString *bookImageLink;//书籍图片链接
@property (nonatomic, copy) NSString *bookDetail;//书籍简介
@property (nonatomic, copy) NSString *bookLowestPrice;//书籍最低价格

- (instancetype)initBook:(NSString*)aName doubanLink:(NSString*)aLink imgLink:(NSString*)bLink  detail:(NSString*)aDetail lowestPrice:(NSString*)aPrice;
@end
