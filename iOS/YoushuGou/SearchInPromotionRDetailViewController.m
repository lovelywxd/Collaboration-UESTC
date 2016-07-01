//
//  SearchInPromotionRDetailViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/1.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "SearchInPromotionRDetailViewController.h"
#import "EGOImageView.h"
#import "PriceComparisonItem.h"
#import "AppDelegate.h"

@interface SearchInPromotionRDetailViewController ()
@property (nonatomic ,strong) NSMutableArray *PriceList;
@end

@implementation SearchInPromotionRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)prepareProperty {
    self.PriceList = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 在活动页搜索获取价格比价表相关
- (void)loadSearchInPromotionRDetail {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    if (appdele.OnLineTest) {
        [self getRDetail];
    }
    else {
        [self getRDetailLocally];
    }
}

- (void)getRDetail {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/search/promotion/detail/",appdele.baseUrl];
    
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.targetItem.promotionBookDetailLink, @"promotionBookDetailLink",nil];
    [appdele.manager
     GET:url
     parameters:param  // 指定请求参数
     // 获取服务器响应成功时激发的代码块
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self formPriceList:responseObject];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"fail search detail in promotion");
     }];
}

- (void)getRDetailLocally {
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"homeSearchDetail" ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    
    NSArray *parseResult = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0 error:nil];
    [self formPriceList:parseResult];
}

#pragma mark -- 公共解析部分
- (void)formPriceList:(NSArray*)arr {
    for (id item in arr) {
        NSString *tempName = [item objectForKey:@"bookSaler"];
        NSRange range = [tempName rangeOfString:@"."];//获取$file/的位置
        NSString *saler = [tempName substringToIndex:range.location];//开始截取
        
        PriceComparisonItem *PriceItem = [[PriceComparisonItem alloc] initSaler:saler withPrice:[item objectForKey:@"bookCurrentPrice"] link:[item objectForKey:@"bookLink"]];
        [self.PriceList addObject:PriceItem];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


@end
