//
//  PromotionViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/25.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "PromotionViewController.h"
@interface PromotionViewController ()

@property (nonatomic,strong) UISegmentedControl *ShopsSegment;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic,strong) NSArray *promotionList;
@property (nonatomic, strong) NSMutableDictionary *shopActivitys;
@property (nonatomic,strong) NSArray *promotionIds;
@property (nonatomic,strong) NSArray *shopWithActivity;
@end

@implementation PromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.ShopsSegment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
    
    
}
@end
