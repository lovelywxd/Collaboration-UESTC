//
//  settingViewController.h
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/12.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingViewController : UIViewController
- (IBAction)submitModdify:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *onLine;

@end
