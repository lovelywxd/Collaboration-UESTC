//
//  CartCell.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/7.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"
#import "EGOImageView.h"

//添加代理，用于按钮加减的实现
@protocol CartCellDelegate <NSObject>
-(void)addBtnClick:(UITableViewCell *)cell;
-(void)minusBtnClick:(UITableViewCell *)cell;
-(void)selectBtnClick:(UITableViewCell *)cell;
@end

@interface CartCell : UITableViewCell
@property (assign, nonatomic) BOOL isSelected;
@property (strong, nonatomic) IBOutlet UILabel *BookName;
@property (strong, nonatomic) IBOutlet UILabel *Price;
@property (strong, nonatomic) IBOutlet UILabel *amout;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) IBOutlet EGOImageView *bookImage;
@property (weak, nonatomic)id<CartCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UITextField *amount;
@property (strong, nonatomic) IBOutlet UIButton *minusBtn;
@property (strong, nonatomic) IBOutlet UIButton *plusBtn;
- (IBAction)minusAmount:(id)sender;
- (IBAction)plusBtn:(id)sender;
- (IBAction)select:(id)sender;

- (void)fillContent:(GoodModel*)good;
@end
