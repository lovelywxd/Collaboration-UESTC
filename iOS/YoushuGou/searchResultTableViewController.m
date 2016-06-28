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
            cell.detailTextLabel.text = @"我听过空境的回忆，雨水浇绿孤山岭，听过被没听过你；我抓住散落的欲望，缱绻的馥郁让我紧张，我抓住时间的假想，没抓住你";
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
        case 1:
        {
            AppDelegate *appdele = [UIApplication sharedApplication].delegate;
            NSString *bookName = @"深入浅出";
            NSString *url1 = @"http://localhost:8000/search/home/list/";
            NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:bookName,@"bookName",nil];
            [appdele.manager GET:url1 parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSLog(@"success in search in homePage step 1");
                 NSString *subjectUrl = @"https://book.douban.com/subject/2130190/";
                  NSDictionary *paras = [[NSDictionary alloc] initWithObjectsAndKeys:subjectUrl,@"bookSubject",nil];
                  NSString *url2 = @"http://localhost:8000/search/home/detail/";
                 [appdele.manager GET:url2 parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject)
                  {
                       NSLog(@"success in search in homePage step 2");
                  }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
                  
                  {
                      NSLog(@"fail in search in homePage  step 2");
                  }];


                 
                 
                 
             }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
             
             {
                 NSLog(@"fail in search in homePage");
             }];

        }
            break;
            
        default:
            break;
    }
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    BookDetailViewController* bookDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewController"];
//    if (self.promotrion.activityType == GroupBuy) {
//        bookDetailVC.IsGroupBuy = YES;
//    }
//    else bookDetailVC.IsGroupBuy = NO;
//    NSString *isbn = [[self.BookList objectAtIndex:indexPath.row] valueForKey:@"PromotionBookISBN"];
//    BookDetailInfo *info = [self.BookDetailList objectForKey:isbn];
//    bookDetailVC.bookdetailInfo = info;
//    [self.navigationController pushViewController:bookDetailVC animated:NO];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
