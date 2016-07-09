//
//  GoodModel.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/8.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodModel : NSObject
@property (nonatomic, copy) NSString *bookISBN;//书籍所ISBN，OK
@property (nonatomic, copy) NSString *bookName;//书籍名称，OK
@property (nonatomic, copy) NSString *bookImageLink;//书籍图片链接，OK
@property (nonatomic, copy) NSString *bookPrice;//书籍图片链接，OK
@property (nonatomic, copy) NSString *relatedPromotionID;//所属的promotion
@property (nonatomic, copy) NSString *promotionName;
@property (nonatomic, copy) NSNumber *amout;//数量
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isEditStyle;


- (instancetype) initWithDictionary:(NSDictionary*)dic;
@end
