//
//  GroupBaseInfoCell.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "GroupBaseInfoCell.h"
#import "Good.h"

@implementation GroupBaseInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillContent:(UserOrderDetail*)uOder {

    self.userName.text = [NSString stringWithString:uOder.userInfo.username];
    self.Phone.text = [NSString stringWithString:uOder.userInfo.phone];
    
    NSArray *bookList = uOder.bookList;
    NSInteger total = 0;
    float total_originalPrice = 0;
//    NSNumber *total = [NSNumber numberWithInt:0];
    for (id book in bookList) {
        Good *goo = (Good*)book;
        NSInteger amout = [goo.amout integerValue];
        total += amout;
        float this_amout = [goo.bookPrice floatValue] * amout;
        total_originalPrice += this_amout;
    }
    
    self.totalAmout.text = [NSString stringWithFormat:@"%ld",total];
    ;
    self.originalPrice.text = [NSString stringWithFormat:@"%.2f",total_originalPrice];
    self.realPrice.text = @"暂定100";
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountList"];
    NSString *headerImgName = dic[uOder.userInfo.username];
    self.header.image = [UIImage imageNamed:headerImgName];
}
@end
