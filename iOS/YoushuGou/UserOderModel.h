//
//  UserOderModel.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserOderModel : NSObject<NSCopying>
@property (nonatomic ,copy) NSString* orderID;
@property (nonatomic ,copy) NSString* promotionID;
//该订单包含的书籍ISBN组合
@property (nonatomic ,copy) NSArray* bookIsbnList;

- (instancetype)init:(NSString*)orderID with:(NSArray*)bookList inPromotion:(NSString*)proID;

@end
