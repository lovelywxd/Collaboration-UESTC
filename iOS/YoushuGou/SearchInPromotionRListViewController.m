//
//  SearchInPromotionRListViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/1.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "SearchInPromotionRListViewController.h"
#import "promotionSearchListItem.h"
#import "EGOImageView.h"
#import "AppDelegate.h"

@interface SearchInPromotionRListViewController ()
@property (nonatomic ,strong) NSMutableArray *searchItemList;
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

@end
