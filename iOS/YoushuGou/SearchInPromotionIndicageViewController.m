//
//  SearchInPromotionIndicageViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/1.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "SearchInPromotionIndicageViewController.h"
#import "SearchInPromotionRListViewController.h"
#import "BookBaseInfo.h"

@interface SearchInPromotionIndicageViewController ()

@end

@implementation SearchInPromotionIndicageViewController

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
            return 1;
            break;
        default:
            return 0;
            break;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    switch (indexPath.section) {
            
        
        case 0:
        {
            BookBaseInfo *info = [self.searchResults objectAtIndex:indexPath.row];
            cell.textLabel.text = info.promotionBookName;
            return cell;
        }
            break;
        case 1:
        {
            cell.textLabel.text = [NSMutableString stringWithFormat:@"搜索书籍:%@",self.searchStr];
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
            BookBaseInfo *info = [self.searchResults objectAtIndex:indexPath.row];
            NSLog(@"selected promotion:%@",info);
            
        }
            break;
        case 1:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NavSearchInPromotionRListViewController"];
            SearchInPromotionRListViewController* rListVC = (SearchInPromotionRListViewController *)navController.topViewController;
            rListVC.targetBookDetailLink = self.searchStr;
            [self presentViewController:navController animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
    
}

@end
