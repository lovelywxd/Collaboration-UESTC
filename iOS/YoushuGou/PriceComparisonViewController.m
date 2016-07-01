//
//  PriceComparisonViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/1.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "PriceComparisonViewController.h"
#import "PriceComparisonItem.h"
#import "PriceComparisonCell.h"
#import "EGOImageView.h"
#import "BookInShopButton.h"
#import "WebViewController.h"

@interface PriceComparisonViewController ()
@property (nonatomic ,copy) NSString *TargetDouBanLink;

@end

@implementation PriceComparisonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 123;
            break;
            
        default:
            return 49;
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        default:
            return self.PriceList.count;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *CellId = @"BaseInfoCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
            EGOImageView *imgView = (EGOImageView*)[cell viewWithTag:1];
            NSString *bookImgUrl = self.bookImageLink;
            imgView.imageURL = [NSURL URLWithString:bookImgUrl];
            UILabel *label;
            label = (UILabel*)[cell viewWithTag:2];
            label.text = self.bookName;
            
            label = (UILabel*)[cell viewWithTag:3];
            label.text = self.bookIsbn;
//
//            UIButton *btn = (UIButton*)[cell viewWithTag:4];
//            [btn addTarget:self action:@selector(GoDouBan:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
            break;
            
        default:
        {

            static NSString *CellId = @"PriceComparisonCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
            PriceComparisonItem *item = [self.PriceList objectAtIndex:indexPath.row];
            EGOImageView *imgView = (EGOImageView*)[cell viewWithTag:1];
            imgView.imageURL = [NSURL URLWithString:item.bookSaler];

            UILabel *label = (UILabel*)[cell viewWithTag:2];
            label.text = item.bookCurrentPrice;
            
            BookInShopButton *btn = (BookInShopButton*)[cell viewWithTag:3];
            btn.shopLink = item.bookLink;
            [btn addTarget:self action:@selector(goBookPageInShop:)forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
            break;
    }
}

#pragma mark - 响应事件
- (void)goBookPageInShop:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController* webVC = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    BookInShopButton* btn = (BookInShopButton*)sender;
    webVC.urlStr = btn.shopLink;
//    NSString *vcTitle = [NSString stringWithFormat:@"《%@》",self.targetItem.bookName];
//    webVC.title = vcTitle;
    [self.navigationController pushViewController:webVC animated:NO];
}

- (void)GoDouBan:(id)sender {
//    NSString *url = self.targetItem.booSubject;
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    WebViewController* webVC = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
//    webVC.urlStr = url;
//    NSString *vcTitle = [NSString stringWithFormat:@"《%@》",self.targetItem.bookName];
//    webVC.title = vcTitle;
//    [self.navigationController pushViewController:webVC animated:NO];
//    NSLog(@"clicked GoDouBan Btn");
}
@end
