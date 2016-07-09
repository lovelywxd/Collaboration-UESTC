//
//  OrderCell.h
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "Good.h"
@interface OrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bookAmout;
@property (strong, nonatomic) IBOutlet UILabel *bookPrice;
@property (strong, nonatomic) IBOutlet UILabel *bookISBN;
@property (strong, nonatomic) IBOutlet EGOImageView *bookCover;
@property (strong, nonatomic) IBOutlet UILabel *bookName;
- (void)fillContent:(Good*)good;
@end
