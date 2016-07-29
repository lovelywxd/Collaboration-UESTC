//
//  userInfoCell.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface userInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *school;
@property (strong, nonatomic) IBOutlet UILabel *email;
@property (strong, nonatomic) IBOutlet UILabel *phone;
@property (strong, nonatomic) IBOutlet UIImageView *header;
@property (strong, nonatomic) IBOutlet UILabel *name;
- (void)fillContent:(UserInfo*)info;
@end
