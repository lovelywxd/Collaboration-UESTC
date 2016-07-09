//
//  SubmitOrderModel.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubmitOrderModel : NSObject
@property (nonatomic ,copy) NSString *submitOrderID;
@property (nonatomic ,copy) NSString *currentStatus;
//Good数组
@property (nonatomic ,copy) NSArray *bookList;

- (instancetype)initWithDictionary:(NSDictionary*)dic;

@end
