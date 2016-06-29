//
//  HomeSearchDetailController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/6/30.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "HomeSearchDetailController.h"
#import "EGOImageView.h"

@interface HomeSearchDetailController ()

@end

@implementation HomeSearchDetailController

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

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
//(NSIndexPath *)indexPath
//{
//switch (indexPath.section) {
//    case 0:
//    {
//        Promotion *pro = [self.searchResults objectAtIndex:indexPath.row];
//        NSLog(@"selected promotion:%@",pro);
//        
//    }
//        break;
//    case 1:
//    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NavHomeSearchResultListController"];;
//        
//        
//        
//        HomeSearchResultListController* homeSearchListVC = (HomeSearchResultListController *)navController.topViewController;
//        
//        homeSearchListVC.searchBookName = self.searchStr;
//    }
//        break;
//}
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
        {
            static NSString *CellId = @"BaseCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
            EGOImageView *imgView = (EGOImageView*)[cell viewWithTag:1];
            NSString *bookImgUrl = self.targetItem.bookImageLink;
            imgView.imageURL = [NSURL URLWithString:bookImgUrl];
            UILabel *label;
            label = (UILabel*)[cell viewWithTag:2];
            label.text = self.targetItem.bookName;
            label = (UILabel*)[cell viewWithTag:3];
            label.text = self.targetItem.bookDetail;
            UIButton *btn = (UIButton*)[cell viewWithTag:4];
            [btn addTarget:self action:@selector(GoDouBan:) forControlEvents:UIControlEventTouchUpInside];
    
        }
            break;
        case 1:
        {
            static NSString *CellId = @"PriceCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
            UIImageView *imgView = (UIImageView*)[cell viewWithTag:1];
            imgView.image = [UIImage imageNamed:@"cart"];
//            UILabel *label;
//            label = (UILabel*)[cell viewWithTag:2];
//            label.text = self.targetItem.bookName;
        }
            break;
    }
    return cell;
}

#pragma mark - 响应事件
- (void)GoDouBan:(id)sender {
    NSLog(@"clicked GoDouBan Btn");
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
