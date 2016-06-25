//
//  ActivityListCell.h
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/24.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *shopsHead;
@property (strong, nonatomic) IBOutlet UILabel *activityName;
@property (nonatomic,copy) NSString *urlStr;
- (IBAction)showActivityDetail:(id)sender;
- (IBAction)goActivityHomePage:(id)sender;

@end
