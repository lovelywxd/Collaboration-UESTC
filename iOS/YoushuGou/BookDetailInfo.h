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

@interface BookDetailInfo : NSObject<NSCopying>
@property (nonatomic,strong) NSDictionary* images;//图片
@property (nonatomic,strong) NSString *title;//书名
@property (nonatomic,strong) NSString *publisher;//出版社
@property (nonatomic,strong) NSString *pubdate;//出版年
@property (nonatomic,assign) NSString *pages;//页数
@property (nonatomic,strong) NSArray *author;//作者
@property (nonatomic,strong) NSString *summary;//书籍简介
@property (nonatomic,strong) NSString *author_intro;//作者简介
@property (nonatomic,strong) NSDictionary* rating;//豆瓣评分
@property (nonatomic,strong) NSString *catalog;//目录
@property (nonatomic,strong) NSArray* tags;//常用标签
@property (nonatomic,copy) NSString* doubanLink;
@property (nonatomic,copy) BookBaseInfo* baseInfo;//书籍售卖信息
- (instancetype)initBook:(BookBaseInfo*)baseInfo withImages:(NSDictionary*)imgs title:(NSString*)bTitle publisher:(NSString*)bPublisher pubdate:(NSString*)bPubdate pages:(NSString*)bPage author:(NSString*)bAuthor summary:(NSString*)bSummary author_intro:(NSString*)authorIntro rating:(NSDictionary*)bRating catalog:(NSString*)bCatalog tags:(NSArray*)bTag doubanLink:(NSString*)bDoubanLink;
@end
