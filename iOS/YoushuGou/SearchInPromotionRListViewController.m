//
//  SearchInPromotionRListViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/1.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "SearchInPromotionRListViewController.h"
#import "promotionSearchListItem.h"
#import "PriceComparisonViewController.h"
#import "PriceComparisonItem.h"
#import "EGOImageView.h"
#import "AppDelegate.h"

@interface SearchInPromotionRListViewController ()
@property (nonatomic ,strong) NSMutableArray *searchItemList;
@property (nonatomic ,copy) promotionSearchListItem *targetItem;
@end

@implementation SearchInPromotionRListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareProperty];
    [self loadSearchInPromitonRlist];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}
- (void) prepareProperty {
    self.searchItemList = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PromotionSearchListItem数据相关
- (void)loadSearchInPromitonRlist {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    if (appdele.OnLineTest) {
        [self getRlist];
    }
    else {
        [self getRlistLocally];
    }
}

- (void)getRlist {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/search/promotion/list/",appdele.baseUrl];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.bookName, @"bookName",self.promotionID,@"promotionID", nil];
    [appdele.manager
     GET:url
     parameters:param  // 指定请求参数
     // 获取服务器响应成功时激发的代码块
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self formRlistFromJsonArr:responseObject];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"fail search in promotion");
     }];
}

- (void)getRlistLocally {
    
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"promotionSearchList"
                                                         ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    NSArray *parseResult = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0 error:nil];
    [self formRlistFromJsonArr:parseResult];
}

#pragma mark -- 数据公共解析部分
- (void) formRlistFromJsonArr:(NSArray*)arr {
    for (id obj in arr) {
        promotionSearchListItem *item = [[promotionSearchListItem alloc] initItem:[obj objectForKey:@"promotionBookISBN"] withName:[obj objectForKey:@"promotionBookName"] price:[obj objectForKey:@"promotionBookPrice"] imageLink:[obj objectForKey:@"promotionBookImageLink"] detailLink:[obj objectForKey:@"promotionBookDetailLink"]];
        [self.searchItemList addObject:item];
        [self.tableView reloadData];
    }
}
#pragma mark - 获取PriceComparisonList 相关
- (void)LoadPriceComparisonList {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    if (appdele.OnLineTest) {
        [self getPriceComparisonList];
    }
    else {
        [self getPriceComparisonListLocally];
    }
}

- (void)getPriceComparisonList {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/search/promotion/detail/",appdele.baseUrl];
    
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.targetItem.promotionBookDetailLink, @"promotionBookDetailLink", nil];
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
         NSLog(@"fail search in promotion");
     }];
}

- (void)getPriceComparisonListLocally {
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"promotionSearchDetail"
                                                         ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    NSArray *parseResult = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0 error:nil];
    [self formPriceList:parseResult];
}

- (void)formPriceList:(NSArray*)arr {
    NSMutableArray *priceList = [[NSMutableArray alloc] init];
    for (id item in arr) {
        PriceComparisonItem *priceitem = [[PriceComparisonItem alloc] initSaler:[item objectForKey:@"bookSaler"] withPrice:[item objectForKey:@"bookCurrentPrice"] link:[item objectForKey:@"bookLink"]];
        [priceList addObject:priceitem];
        
    }
    
    //数据加载完以后切换页面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
//    UINavigationController *navVC = [storyboard instantiateViewControllerWithIdentifier:@"NavHomeSearchDetailController"];
//    PriceComparisonViewController *detailVC = (PriceComparisonViewController*)navVC.topViewController;
    
    PriceComparisonViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"PriceComparisonViewController"];
    detailVC.PriceList = [priceList copy];
    detailVC.bookIsbn = self.targetItem.promotionBookISBN;
    detailVC.bookImageLink = self.targetItem.promotionBookImageLink;
    detailVC.bookName = self.targetItem.promotionBookName;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchItemList.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellId = @"SearInPromotionRListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellId];
    }
    promotionSearchListItem *item = [self.searchItemList objectAtIndex:indexPath.row];
    if (item) {
        EGOImageView *imgView = (EGOImageView*)[cell viewWithTag:1];
        NSString *bookImgUrl = item.promotionBookImageLink;
        imgView.imageURL = [NSURL URLWithString:bookImgUrl];
        
        UILabel *label;
        label = (UILabel*)[cell viewWithTag:2];
        label.text = item.promotionBookName;
        
        label = (UILabel*)[cell viewWithTag:3];
        label.text = item.promotionBookISBN;
        
        label = (UILabel*)[cell viewWithTag:4];
        label.text = item.promotionBookPrice;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath
{
    self.targetItem = [self.searchItemList objectAtIndex:indexPath.row];
    [self LoadPriceComparisonList];
}

- (IBAction)Back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
