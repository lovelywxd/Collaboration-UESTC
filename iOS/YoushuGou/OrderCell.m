//
//  OrderCell.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillContent:(Good*)good {
    self.bookCover.imageURL = [NSURL URLWithString:good.bookImageLink];
    self.bookName.text = good.bookName;
    self.bookISBN.text = good.bookISBN;
    self.bookPrice.text = good.bookPrice;
    self.bookAmout.text = [NSString stringWithFormat:@"%@",good.amout];
}

@end
