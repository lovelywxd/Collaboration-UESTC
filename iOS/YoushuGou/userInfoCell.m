//
//  userInfoCell.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "userInfoCell.h"

@implementation userInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillContent:(UserInfo*)info {
    self.name.text = info.username;
    self.phone.text = info.phone;
    self.email.text = info.email;
    self.school.text = info.school;
    
    NSDictionary *headerDic =[[NSUserDefaults standardUserDefaults] valueForKey:@"accountList"];

    self.header.image = [UIImage imageNamed:headerDic[info.username]];
}
@end
