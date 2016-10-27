//
//  Header.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/8/14.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>

UIColor* getColor(NSInteger rgbColor)
{
    CGFloat arg1 = ((rgbColor & 0xFF0000) >> 16) / 255.0;
    CGFloat arg2 = ((rgbColor & 0x00FF00) >> 8 ) / 255.0;
    CGFloat arg3 = ((rgbColor & 0x0000FF) >> 0 ) / 255.0;
    CGFloat arg4 = 1.0;
    
    UIColor *col = [[UIColor alloc] initWithRed:arg1 green:arg2 blue:arg3 alpha:arg4];
    return col;
}