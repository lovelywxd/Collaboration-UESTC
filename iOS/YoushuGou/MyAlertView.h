//
//  MyAlertView.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAlertView : UIAlertView

@property (nonatomic ,copy) NSString *confirm;
@property (nonatomic ,copy) NSString *orderStatus;
@property (nonatomic ,copy) NSString *promotionID;
@property (nonatomic ,copy) NSString *orderID;

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id /*<UIAlertViewDelegate>*/)delegate acceptButtonTitle:(nullable NSString *)acceptBtnTitle declineButtonTitle:(nullable NSString *)declineBtnTitle;


//- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_EXTENSION_UNAVAILABLE_IOS("Use UIAlertController instead.");

//- (void)
//[UIAlertView alloc]initWithTitle:@"拼单结果" message:msg delegate:nil cancelButtonTitle:@"接受" otherButtonTitles:@"拒绝", nil
@end
