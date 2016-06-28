//
//  BookBaseInfo.h
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/26.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//此类中的数据为服务器返回的书籍的基本信息，客户端根据基本信息向豆瓣请求书籍详细信息

@interface BookBaseInfo : NSObject<NSCopying>
@property (nonatomic,copy) NSString *PromotionBookISBN;//书籍所ISBN，OK
//@property (nonatomic,copy) NSString *PromotionID;//书籍所在的活动ID
@property (nonatomic,copy) NSString* PromotionBookPrice;//书籍定价，OK
@property (nonatomic,copy) NSString* PromotionBookCurrentPrice;//书籍在此活动的价格，OK
@property (nonatomic ,copy) NSString *PromotionBookSearchLink;//搜索书籍时使用的链接，OK
- (instancetype)initBook:(NSString*)Isbn withOriginalPrice:(NSString*)oPrice currentPrice:(NSString*)cPrice inPromotion:(NSString*)promotionId;
@end
