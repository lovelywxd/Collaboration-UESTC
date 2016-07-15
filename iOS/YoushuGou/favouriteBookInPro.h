//
//  favouriteBookInPro.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/15.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface favouriteBookInPro : NSObject
@property (nonatomic ,copy) NSString *bookISBN;
//key：promotionID，value书的新价格
@property (nonatomic ,copy) NSDictionary *priceList;
- (instancetype)initWithDic:(NSDictionary*)dic;
@end
