//
//  FavouriteViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/2.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "FavouriteViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "FavouriteItem.h"
@interface FavouriteViewController ()
{
    MBProgressHUD *hud;
    MBProgressHUD *removeHud;
}
@property (nonatomic ,strong) NSMutableArray* FavoriteList;
@end

@implementation FavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareProperty];
    [self loadFavouriteList];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareProperty {
    self.FavoriteList = [[NSMutableArray alloc] init];
}

#pragma mark -FavouriteList相关

- (void)loadFavouriteList {
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    
    // Set the label text.
    hud.label.text = NSLocalizedString(@"加载书籍列表...", @"HUD loading title");
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    if (appdele.OnLineTest) {
        [self getFavouriteList];
    }
    else {
        [self getFavouriteListLocally];
    }

}

- (void)getFavouriteList {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/favourite/list/",appdele.baseUrl];

    [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *staus = [responseObject objectForKey:@"status"];
         if ([staus isEqualToString:@"0"]) {
             
             NSArray *listArr = [[responseObject objectForKey:@"data"] objectForKey:@"favourite_list"];
             [self formFavouriteList:listArr];
         }
         else {
             NSString *result = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"收藏信息获取失败" message:result preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [hud hideAnimated:YES];
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"收藏信息获取失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
     }];

}

- (void)getFavouriteListLocally {
    // 获取JSON文件所在的路径
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"collection"  ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
     NSArray *listArr = [[responseObject objectForKey:@"data"] objectForKey:@"favourite_list"];
    [self formFavouriteList:listArr];
}

- (void)formFavouriteList:(NSArray*)arr {
    for (id obj in arr) {
        FavouriteItem *item = [[FavouriteItem alloc] initBook:[obj objectForKey:@"bookISBN"] name:[obj objectForKey:@"bookName"] imageLink:[obj objectForKey:@"bookImageLink"]];
        [self.FavoriteList addObject:item];
    }
    [hud hideAnimated:YES];
    [self.tableView reloadData];
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.FavoriteList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavouriteCell" forIndexPath:indexPath];
    FavouriteItem *item = [self.FavoriteList objectAtIndex:indexPath.row];

    UILabel *label;
    label = (UILabel*)[cell viewWithTag:2];
    label.text = item.bookName;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        FavouriteItem *item = [self.FavoriteList objectAtIndex:indexPath.row];
        AppDelegate *appdele = [UIApplication sharedApplication].delegate;
        NSString *url = [NSString stringWithFormat:@"%@/favourite/remove/",appdele.baseUrl];
        removeHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        removeHud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
        removeHud.label.text = NSLocalizedString(@"删除中", @"HUD loading title");
        [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
        NSString* isbn = item.bookISBN;
        NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:isbn,@"bookISBN", nil];
        [appdele.manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"success in search in removeFavorite");
            [removeHud hideAnimated:YES];
             NSString *status = [responseObject objectForKey:@"status"];
             if ([status isEqualToString:@"0"]) {
                 [self.FavoriteList removeObject:item];
                 [self.tableView reloadData];
             }
             else {
                 NSString *result = [NSString stringWithFormat:@"删除失败.info:%@",[responseObject objectForKey:@"data"]];
                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"删除收藏" message:result preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                 }];
                 [alert addAction:defaultAction];
                 [self presentViewController:alert animated:YES completion:nil];
             }
         }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         
         {
             [removeHud hideAnimated:YES];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"删除收藏失败" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }];
    }
}

@end
