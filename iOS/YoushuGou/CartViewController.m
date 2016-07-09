
//
//  CartViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/2.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "CartViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "Good.h"
#import "EGOImageView.h"
#import "MJRefresh.h"

@interface CartViewController ()
{
    MBProgressHUD *hud;
    MBProgressHUD *removeHud;
    
}
@property (nonatomic ,strong) NSMutableArray *goodList;
@property (nonatomic ,strong) NSMutableDictionary *promotionGoods;
@property (nonatomic ,strong) NSMutableArray *allPromotion;
@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareProperty];
    [self loadGoodsList];
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadGoodsList];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareProperty {
    self.goodList = [[NSMutableArray alloc] init];
    self.promotionGoods = [[NSMutableDictionary alloc] init];
}


#pragma mark - 获取购物车商品列表
- (void)loadGoodsList {
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    hud.label.text = NSLocalizedString(@"加载购物车列表...", @"HUD loading title");
    
    [self prepareProperty];
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    if (appdele.OnLineTest) {
        [self getGoodsList];
    }
    else {
        [self getGoodsListLocally];
    }

}


- (void) getGoodsList {
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/shopping/list/",appdele.baseUrl];
    [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
    [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *status = [responseObject objectForKey:@"status"];
         if ([status isEqualToString:@"0"]) {
             NSArray *allBooks = [[responseObject objectForKey:@"data"] objectForKey:@"shopping_list"];
             [self formGoodsList:allBooks];
         }
         else {
             NSString *result = [NSString stringWithFormat:@"info:%@",[responseObject objectForKey:@"data"]];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"获取购物车列表失败" message:result preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
     }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [hud hideAnimated:YES];
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"获取购物车列表失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
         
     }];

    
}

- (void) getGoodsListLocally {
//    Good *item = [[Good alloc] initBook:@"1234560" name:@"书本1234560" imageLink:@"1234560" price:@"123" inPromotionID:@"pro123" promotionName:@"proName123" amout:@"4"];
//    [self.goodList addObject:item];
//    item = [[Good alloc] initBook:@"1234561" name:@"书本1234561" imageLink:@"1234561" price:@"123"  inPromotionID:@"pro123" promotionName:@"proName123" amout:@"4"];
//    [self.goodList addObject:item];
//    item = [[Good alloc] initBook:@"1234562" name:@"书本1234562" imageLink:@"1234562" price:@"123" inPromotionID:@"pro456" promotionName:@"proName456" amout:@"4"];
//    [self.goodList addObject:item];
//    [self classify:self.goodList];
    
    // 获取JSON文件所在的路径
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"orderList"
                                                         ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    
//    NSArray *parseResult = [NSJSONSerialization JSONObjectWithData:data
//                                                           options:0 error:nil];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0 error:nil];
    NSString *status = [responseObject objectForKey:@"status"];
    if ([status isEqualToString:@"0"]) {
        NSArray *allBooks = [[responseObject objectForKey:@"data"] objectForKey:@"shopping_list"];
        [self formGoodsList:allBooks];
    }
    else {
        NSString *result = [NSString stringWithFormat:@"info:%@",[responseObject objectForKey:@"data"]];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"获取购物车列表失败" message:result preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [hud hideAnimated:YES];
}

- (void)formGoodsList:(NSArray*)arr {
    for (id obj in arr) {
        NSNumber *bookAmout = [obj objectForKey:@"bookAmount"];
        Good *item = [[Good alloc] initBook:[obj objectForKey:@"promotionBookISBN"] name:[obj objectForKey:@"bookName"] imageLink:[obj objectForKey:@"promotionBookImageLink"] price:[obj objectForKey:@"promotionBookPrice"] inPromotionID:[obj objectForKey:@"promotionID"] promotionName:[obj objectForKey:@"promotionName"] amout:[NSString stringWithFormat:@"%@",bookAmout]];
        [self.goodList addObject:item];
    }
    
    [hud hideAnimated:YES];
    [self classify:self.goodList];
    [self.tableView reloadData];
}

- (void) classify:(NSArray*)list {
    for (id good in list) {
        NSString *proID = [good valueForKey:@"relatedPromotionID"];
        NSMutableArray *relatedBooks = [self.promotionGoods objectForKey:proID];
        if (relatedBooks) {
            [relatedBooks addObject:good];
        }
        else {
            NSMutableArray *relatedBooks = [[NSMutableArray alloc] initWithObjects:good, nil];
            [self.promotionGoods setObject:relatedBooks forKey:proID];
        }
        
    }
    self.allPromotion = [NSMutableArray arrayWithArray:[self.promotionGoods allKeys]];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allPromotion.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *books = [self.promotionGoods objectForKey:[self.allPromotion objectAtIndex:section]];
    return books.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodCell" forIndexPath:indexPath];
     NSArray *books = [self.promotionGoods objectForKey:[self.allPromotion objectAtIndex:indexPath.section]];
    Good *item = [books objectAtIndex:indexPath.row];
    
    EGOImageView *imgView = (EGOImageView*)[cell viewWithTag:1];
    imgView.imageURL = [NSURL URLWithString:item.bookImageLink];

    
    UILabel *label;
    label = (UILabel*)[cell viewWithTag:2];
    label.text = item.bookName;
    
    label = (UILabel*)[cell viewWithTag:3];
    label.text = item.bookPrice;
    
    label = (UILabel*)[cell viewWithTag:4];
    label.text = item.bookISBN;
    
    label = (UILabel*)[cell viewWithTag:5];
    label.text = item.amout;
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *books = [self.promotionGoods objectForKey:[self.allPromotion objectAtIndex:section]];
    NSString *title = [books[0] valueForKey:@"promotionName"];
    return title;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        removeHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        removeHud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
        removeHud.label.text = NSLocalizedString(@"删除中", @"HUD loading title");

        
        AppDelegate *appdele = [UIApplication sharedApplication].delegate;
        NSString *url = [NSString stringWithFormat:@"%@/shopping/remove/",appdele.baseUrl];
        

        NSString *promotionID = [self.allPromotion objectAtIndex:indexPath.section];
        Good *item = [[self.promotionGoods objectForKey:promotionID] objectAtIndex:indexPath.row];
        NSString *isbn = item.bookISBN;
        
        [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
        NSArray *bookList = [NSArray arrayWithObjects:isbn, nil];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:promotionID,@"promotionID", bookList,@"bookList",nil];
        NSArray *param = [NSArray arrayWithObjects:dic,nil];
        
        [appdele.manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"success in search in removeFavorite");
             [removeHud hideAnimated:YES];
             NSString *status = [responseObject objectForKey:@"status"];
             if ([status isEqualToString:@"0"]) {
                 
//                 NSMutableArray* books = [NSMutableArray arrayWithArray:[self.promotionGoods objectForKey:[self.allPromotion objectAtIndex:indexPath.section]]];
//                 Good *item = [books objectAtIndex:indexPath.row];
//                 [books removeObject:item];
                 
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
             NSLog(@"fail in search in removeFavorite");
         }];

        
    }
}

- (IBAction)commitAll:(id)sender {

    NSMutableArray *result = [[NSMutableArray alloc] init];
    
//    for (id proID in self.allPromotion) {
//        NSArray *goods = [self.promotionGoods objectForKey:proID];
//        NSMutableArray *bookList = [[NSMutableArray alloc] init];
//        for (id good in goods) {
//            NSString *isbn = [good valueForKey:@"bookISBN"];
//            NSString *price = [good valueForKey:@"bookPrice"];
//            NSDictionary *book = [[NSDictionary alloc] initWithObjectsAndKeys:isbn,@"bookISBN",price,@"promotionbookPrice", nil];
//            [bookList addObject:book];
//        }
//        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:proID,@"promotionID",bookList,@"promotionBookPrice", nil];
//        [result addObject:dic];
//    }
    
        for (id proID in self.allPromotion) {
            NSArray *goods = [self.promotionGoods objectForKey:proID];
            NSMutableArray *bookList = [[NSMutableArray alloc] init];
            for (id good in goods) {
                NSString *isbn = [good valueForKey:@"bookISBN"];
                [bookList addObject:isbn];
            }
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:proID,@"promotionID",bookList,@"bookList", nil];
            [result addObject:dic];
        }
    
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/order/submit/",appdele.baseUrl];
    [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
    [appdele.manager POST:url parameters:result success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *status = [responseObject objectForKey:@"status"];
         if ([status isEqualToString:@"0"]) {
             NSArray *allBooks = [[responseObject objectForKey:@"data"] objectForKey:@"shopping_list"];
             [self formGoodsList:allBooks];
         }
         else {
             NSString *result = [NSString stringWithFormat:@"info:%@",[responseObject objectForKey:@"data"]];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提交订单失败失败" message:result preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
     }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {

         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"提交订单失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
         
     }];

}

#pragma mark - 辅助函数
- (void) printSet:(NSSet*)aSet {
    NSLog(@"count is:%ld",aSet.count);
    NSEnumerator *enumerator = [aSet objectEnumerator];
    id value;
    while ((value = [enumerator nextObject])) {
        NSLog(@"%@,",value);
    }
}
@end
