//
//  UserCentralViewController.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/2.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;

@interface UserCentralViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *UserNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *header;
@property (strong, nonatomic) IBOutlet UITextField *personalState;

@property (strong, nonatomic) IBOutlet EGOImageView *egoHeader;


@end
