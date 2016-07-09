//
//  MyAlertView.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "MyAlertView.h"

@implementation MyAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id /*<UIAlertViewDelegate>*/)delegate acceptButtonTitle:(nullable NSString *)acceptBtnTitle declineButtonTitle:(nullable NSString *)declineBtnTitle {
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:acceptBtnTitle otherButtonTitles:declineBtnTitle, nil];
    return  self;
}

@end
