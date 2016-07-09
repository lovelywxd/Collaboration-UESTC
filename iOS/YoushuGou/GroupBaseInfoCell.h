//
//  GroupBaseInfoCell.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "UserOrderDetail.h"

@interface GroupBaseInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *realPrice;
@property (strong, nonatomic) IBOutlet UILabel *originalPrice;
@property (strong, nonatomic) IBOutlet UILabel *totalAmout;
@property (strong, nonatomic) IBOutlet UILabel *Phone;
@property (strong, nonatomic) IBOutlet EGOImageView *head;
@property (strong, nonatomic) IBOutlet UILabel *userName;

- (void)fillContent:(UserOrderDetail*)uOder;
@end
