//
//  FavouriteItem.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/2.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavouriteItem : NSObject
@property (nonatomic,copy) NSString *bookISBN;//书籍所ISBN，OK
@property (nonatomic,copy) NSString *bookName;//书籍名称，OK
@property (nonatomic ,copy) NSString *bookImageLink;//书籍图片链接，OK
- (instancetype)initBook:(NSString*)isbn name:(NSString*)bName imageLink:(NSString*)bLink;
@end
