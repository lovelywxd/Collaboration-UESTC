//
//  groupBuyViewController.h
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/17.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>


//@interface groupBuyViewController : baseViewController
@interface groupBuyViewController : UIViewController
- (IBAction)SearchBook:(id)sender;
- (IBAction)loadImg:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *imgIndex;
@end
