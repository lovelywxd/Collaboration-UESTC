//
//  CoderUserDetailController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "CoderUserDetailController.h"
#import "userInfoCell.h"
#import "OrderCell.h"

@interface CoderUserDetailController ()

@end

@implementation CoderUserDetailController

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
            
        default:
        {
            return self.orderDetail.bookList.count;
        }
            break;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            BOOL nibsRegistered=NO;
            
            static NSString *cellID = @"userInfoCell";
            if (!nibsRegistered) {
                UINib *nib=[UINib nibWithNibName:@"userInfoCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:cellID];
                nibsRegistered=YES;
            }
            userInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            [cell fillContent:self.orderDetail.userInfo];
            return cell;
        }
            break;
            
        default:
        {
            BOOL nibsRegistered=NO;
            static NSString *cellID = @"OrderCell";
            if (!nibsRegistered) {
                UINib *nib=[UINib nibWithNibName:@"OrderCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:cellID];
                nibsRegistered=YES;
            }
            OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            NSArray *goods = self.orderDetail.bookList;
            [cell fillContent:[goods objectAtIndex:indexPath.row]];
            return cell;

        }
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 146;
            break;
            
        default:
            return 123;
            break;
    }
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
