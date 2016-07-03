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
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface PriceComparisonViewController ()
{
    MBProgressHUD *hud;
}
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
            
            UIButton *btn = (UIButton*)[cell viewWithTag:4];
            [btn addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)collect:(id)sender {
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    // Set the label text.
    hud.label.text = NSLocalizedString(@"收藏中", @"HUD loading title");
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/favourite/add/",appdele.baseUrl];
    
    [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
    
    NSString *isbn = self.bookIsbn;
    NSString *bookName = self.bookName;
    NSString *bookImageLink = self.bookImageLink;
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:bookName,@"bookname",nil];

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:bookName,@"bookName",isbn,@"ISBN",bookImageLink,@"bookImageLink",nil];
    
    
    
    [appdele.manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [hud hideAnimated:YES];
         NSString *status = [responseObject objectForKey:@"status"];
         if ([status isEqualToString:@"0"]) {
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"收藏" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
             
         }
         else {
             NSString *result = [NSString stringWithFormat:@"收藏失败.info:%@",[responseObject objectForKey:@"data"]];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"收藏" message:result preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
     }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [hud hideAnimated:YES];
         NSLog(@"fail in search in addFavorite");
     }];

}
@end
