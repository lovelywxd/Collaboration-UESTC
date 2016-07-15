//
//  ComeBineOrderModel.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComeBineOrderModel : NSObject<NSCopying>
@property (nonatomic ,copy) NSString* promotionID;
@property (nonatomic ,copy) NSNumber* currentStatus;
@property (nonatomic ,copy) NSString* combineOrderID;
@property (nonatomic ,copy) NSString* submitOrderID;
@property (nonatomic ,copy) NSString* submitOrderPrice;
@property (nonatomic ,copy) NSString* comineOrderPrice;
@property (nonatomic ,copy) NSString* combineNeedPrice;
@property (nonatomic ,copy) NSString* submitNeedPrice;
@property (nonatomic ,copy) NSString* combineTime;
@property (nonatomic ,copy) NSString* combineTimeLimited;

- (instancetype)initWihtDictionary:(NSDictionary*)dic;
- (instancetype)initCombineOrder:(NSString*)CoID withUsrOrder:(NSString*)UoID status:(NSNumber*)state promotion:(NSString*)proID submitOderPirce:(NSString*)SoPrice combineOrderPrice:(NSString*)CoPrice submitNeedPrice:(NSString*)SnPrice combineNeedPrice:(NSString*)CnPrice combineTime:(NSString*)cTime combineTimeLimited:(NSString*)CtlTime;
@end
