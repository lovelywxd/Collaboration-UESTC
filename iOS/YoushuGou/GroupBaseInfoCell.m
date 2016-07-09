//
//  GroupBaseInfoCell.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "GroupBaseInfoCell.h"

@implementation GroupBaseInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillContent:(UserOrderDetail*)uOder {
//    self.userName.text = @"暂定";
//    self.Phone.text = @"暂定1552";
    self.userName.text = [NSString stringWithString:uOder.userInfo.username];
    self.Phone.text = [NSString stringWithString:uOder.userInfo.phone];
    self.totalAmout.text = @"暂定4";
    self.originalPrice.text = @"暂定200";
    self.realPrice.text = @"暂定100";
}
@end
