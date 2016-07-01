//
//  searchResultTableViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/21.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "searchResultTableViewController.h"
#import "PromotionCell.h"
#import "AppDelegate.h"
#import "AFURLRequestSerialization.h"
#import "HomeSearchResultListController.h"

@interface searchResultTableViewController ()

@end

@implementation searchResultTableViewController
NSMutableArray* historySearch;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    historySearch = [NSMutableArray arrayWithObjects:@"history1",@"history2",@"history3", nil];
//    self.navigationController.navigationBar.hidden = YES;
//    self.definesPresentationContext = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 2;

}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return @"网络结果";
            break;
        default:
            return @"";
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.searchResults.count;
            break;
        case 1:
            return 2;
            break;
        default:
            return 0;
            break;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            // 为表格行定义一个静态字符串作为标示符
            static NSString* cellId = @"cellId";
            PromotionCell* cell = [tableView
                                   dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[PromotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.promotion = [self.searchResults objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"Amazon"];
            
            cell.textLabel.text = [cell.promotion valueForKey:@"promotionName"];
//            cell.detailTextLabel.text = @"我听过空境的回忆，雨水浇绿孤山岭，听过被没听过你；我抓住散落的欲望，缱绻的馥郁让我紧张，我抓住时间的假想，没抓住你";
            return cell;

        }
            break;
        case 1:
        {
            static NSString* cellId = @"searchResult";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            switch (indexPath.row) {
                case 0:
                    label.text = [NSMutableString stringWithFormat:@"搜索书籍:%@",self.searchStr];
                    break;
                case 1:
                    label.text = [NSMutableString stringWithFormat:@"搜索活动:%@",self.searchStr];
                    break;
                default:
                    break;
            }
            return cell;
        }
        break;
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            Promotion *pro = [self.searchResults objectAtIndex:indexPath.row];
            NSLog(@"selected promotion:%@",pro);
            
        }
            break;
        case 1:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NavHomeSearchResultListController"];;
            
         

            HomeSearchResultListController* homeSearchListVC = (HomeSearchResultListController *)navController.topViewController;
//            HomeSearchResultListController* homeSearchListVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeSearchResultListController"];;

            
            homeSearchListVC.searchBookName = self.searchStr;
            
//            [self.navigationController pushViewController:homeSearchListVC animated:YES];
            [self presentViewController:navController animated:YES completion:nil];
            
        }
            break;
            
        default:
            break;
    }
}

@end
