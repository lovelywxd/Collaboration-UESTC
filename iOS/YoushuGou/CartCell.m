//
//  CartCell.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/7.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "CartCell.h"


@implementation CartCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//根据传进来的good填充cell中控件的内容
- (IBAction)minusAmount:(id)sender {
    [self.delegate minusBtnClick:self];
}

- (IBAction)plusBtn:(id)sender {
    [self.delegate addBtnClick:self];
}

- (IBAction)select:(id)sender {
    [self.delegate selectBtnClick:self];
}

- (void)fillContent:(GoodModel*)good {
            [self.selectBtn setImage:[UIImage imageNamed:@"select-sel"] forState:UIControlStateNormal];

    
    if (!good.isSelected) {
         [self.selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    }
    else {
        [self.selectBtn setImage:[UIImage imageNamed:@"select-sel"] forState:UIControlStateNormal];
    }
    

    self.BookName.text = good.bookName;
    self.Price.text = good.bookPrice;
    self.amout.text = [NSString stringWithFormat:@"%@",good.amout];
    self.bookImage.imageURL = [NSURL URLWithString:good.bookImageLink];
    self.amount.text = [NSString stringWithFormat:@"%@",good.amout];
    
    if (!good.isEditStyle) {
        self.minusBtn.hidden = YES;
        self.amount.hidden = YES;
        self.plusBtn.hidden = YES;
        self.amout.hidden = NO;
        self.BookName.hidden = NO;
        self.Price.hidden = NO;
    }
    else {
        self.minusBtn.hidden = NO;
        self.amount.hidden = NO;
        self.plusBtn.hidden = NO;
        self.amout.hidden = YES;
        self.BookName.hidden = YES;
        self.Price.hidden = YES;
    }
}

@end
