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
#import "PromotionDetailViewController.h"
#import "WebViewController.h"




@interface searchResultTableViewController ()

@end

@implementation searchResultTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
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
            static NSString* cellId = @"searchResultTableViewControllerCell";
            PromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            cell.promotion = [self.searchResults objectAtIndex:indexPath.row];
            
            UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",cell.promotion.promotionCompany]];
            
            UILabel *label = (UILabel*)[cell viewWithTag:2];
            label.text = [cell.promotion valueForKey:@"promotionName"];
            return cell;

        }
            break;
        case 1:
        {
            static NSString* cellId = @"searchResult";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                                cell = [[PromotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                            }

            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSMutableString stringWithFormat:@"搜索书籍:%@",self.searchStr];
                    break;
                case 1:
                    cell.textLabel.text = [NSMutableString stringWithFormat:@"搜索活动:%@",self.searchStr];
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
            [self.promotionDelegate navigateToPromotion:pro];
        }
            break;
        case 1:
        {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NavHomeSearchResultListController"];;
                HomeSearchResultListController* homeSearchListVC = (HomeSearchResultListController *)navController.topViewController;
                homeSearchListVC.searchBookName = self.searchStr;
                [self presentViewController:navController animated:YES completion:nil];

        }
            break;
            
        default:
            break;
    }

}



@end
