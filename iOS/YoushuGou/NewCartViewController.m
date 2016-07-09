//
//  NewCartViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/7.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "NewCartViewController.h"
#import "GoodModel.h"
#import "CartCell.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "EGOImageView.h"
#import "UserOderModel.h"
#import "MJRefresh.h"

@interface NewCartViewController ()<UITableViewDelegate,UITableViewDataSource,CartCellDelegate>
{
    MBProgressHUD *hud;
    MBProgressHUD *removeHud;
    float allPrice;
    //每次进入编辑状态后，先把之前的数据备份下来，最后提交时有差异的数据发给服务器
    NSMutableDictionary *previousGoodList;
    NSArray *lastSubmitList;

}
//GoodModel数组，未根据promotion分类
@property (nonatomic ,strong) NSMutableArray *goodList;
//key：promotionName
//value: 对应promotion下的GoodModel数组
@property (nonatomic ,strong) NSMutableDictionary *promotionGoods;
//购物车中所有商品涉及的promotion数组
@property (nonatomic ,strong) NSMutableArray *allPromotion;

@end

@implementation NewCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isSelectedAll = NO;
    self.isEditState = NO;
    self.deleteBtn.hidden = YES;
    self.table.dataSource = self;
    self.table.delegate = self;
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadGoodsList];
    }];
    // 马上进入刷新状态
    [self.table.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareProperty {
    self.goodList = [[NSMutableArray alloc] init];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - 获取数据源

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
    [self calTotalPrice];
    [self.table reloadData];
    
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

    
    // 获取JSON文件所在的路径
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"cartList"  ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
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
    [self.table.mj_header endRefreshing];

    for (id obj in arr) {
        GoodModel *good = [[GoodModel alloc] initWithDictionary:obj];
        [self.goodList addObject:good];
    }
    [hud hideAnimated:YES];
    [self classify:self.goodList];
    [self.table reloadData];
}

- (void) classify:(NSArray*)list {
    self.promotionGoods = [[NSMutableDictionary alloc] init];
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

#pragma mark - tableView datasource 和tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 91;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allPromotion.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *books = [self.promotionGoods objectForKey:[self.allPromotion objectAtIndex:section]];
    return books.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *booksInAPro = [self.promotionGoods objectForKey:[self.allPromotion objectAtIndex:indexPath.section]];
    
    GoodModel *goodModel = [booksInAPro objectAtIndex:indexPath.row];
    
    
    BOOL nibsRegistered=NO;
    static NSString *cellID = @"CartCell";
    if (!nibsRegistered) {
        UINib *nib=[UINib nibWithNibName:@"CartCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        nibsRegistered=YES;
    }
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
    [cell fillContent:goodModel];

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

//- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        removeHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        removeHud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
//        removeHud.label.text = NSLocalizedString(@"删除中", @"HUD loading title");
//        
//        
//        AppDelegate *appdele = [UIApplication sharedApplication].delegate;
//        NSString *url = [NSString stringWithFormat:@"%@/order/remove/",appdele.baseUrl];
//        
//        
//        NSString *promotionID = [self.allPromotion objectAtIndex:indexPath.section];
//        Good *item = [[self.promotionGoods objectForKey:promotionID] objectAtIndex:indexPath.row];
//        NSString *isbn = item.bookISBN;
//        
//        [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
//        NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:promotionID,@"promotionID", isbn,@"bookISBN",nil];
//        
//        [appdele.manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
//         {
//             NSLog(@"success in search in removeFavorite");
//             [removeHud hideAnimated:YES];
//             NSString *status = [responseObject objectForKey:@"status"];
//             if ([status isEqualToString:@"0"]) {
//                 
//                 NSArray *books = [self.promotionGoods objectForKey:[self.allPromotion objectAtIndex:indexPath.section]];
//                 
//                 Good *item = [books objectAtIndex:indexPath.row];
//                 
//                 [self.tableView reloadData];
//             }
//             else {
//                 NSString *result = [NSString stringWithFormat:@"删除失败.info:%@",[responseObject objectForKey:@"data"]];
//                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"删除收藏" message:result preferredStyle:UIAlertControllerStyleAlert];
//                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                 }];
//                 [alert addAction:defaultAction];
//                 [self presentViewController:alert animated:YES completion:nil];
//             }
//         }
//                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
//         
//         {
//             [removeHud hideAnimated:YES];
//             NSLog(@"fail in search in removeFavorite");
//         }];
//        
//        
//    }
//}
#pragma mark - 数据处理
- (void)updateAllEditState:(BOOL)newState {
    for (id key in self.promotionGoods) {
        NSArray *goods = self.promotionGoods[key];
        for (NSInteger i = 0; i < goods.count; ++ i) {
            GoodModel *item = (GoodModel*)goods[i];
            item.isEditStyle = newState;
        }
    }
}

- (void)updateAllSelectState:(BOOL)newState {
    for (id key in self.promotionGoods) {
        NSArray *goods = self.promotionGoods[key];
        for (NSInteger i = 0; i < goods.count; ++ i) {
            GoodModel *item = (GoodModel*)goods[i];
            item.isSelected = newState;
        }
    }
}
- (NSArray*)comepare:(NSDictionary*)new withPrevious:(NSDictionary*)old {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id key in previousGoodList) {
        NSArray *newGoods = self.promotionGoods[key];
        NSArray *oldGoods = previousGoodList[key];
        NSMutableArray *diffOfAPro = [[NSMutableArray alloc] init];
        if (newGoods == nil) {
            //说明将某项活动的书籍都删除了
            
            
            NSArray *diff = [oldGoods copy];
            //把该活动下的所有书的数量设置为0
            for (id obj in oldGoods) {
                GoodModel *item = (GoodModel*)obj;
                 NSDictionary *bookDic = [[NSDictionary alloc] initWithObjectsAndKeys:item.bookISBN,@"bookISBN",item.amout,@"bookAmount", nil];
                [diffOfAPro addObject:bookDic];
            }
        }
        else {
//             比较该活动下的每本书的数量差异

            for (id obj in oldGoods) {
                GoodModel *oldItem = (GoodModel*)obj;
                NSString *isbn = oldItem.bookISBN;
                BOOL findFlag = NO;//指示在修改后的某个活动的下的购物车列表中是否有旧的列表中的某本书
                for (id newobj in newGoods) {
                    GoodModel *newItem = (GoodModel*)newobj;
                    if ([newItem.bookISBN isEqualToString:isbn]) {
                        findFlag = true;
                        if (![newItem.amout isEqualToNumber:oldItem.amout]) {
                            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:isbn,@"bookISBN",newItem,@"bookAmount", nil];
                            [diffOfAPro addObject:dic];
                            
                        }
                        findFlag = YES;
                        break;
                    }
                }
                if (!findFlag) {
//                    在同一活动的新书籍列表中无法找到旧的书籍列表的某一本书
                     NSDictionary *bookDic = [[NSDictionary alloc] initWithObjectsAndKeys:isbn,@"bookISBN",[NSNumber numberWithInt:0],@"bookAmount", nil];
                    [diffOfAPro addObject:bookDic];
                }
                 
            } //for (id obj in oldGoods)
          
        }
        NSDictionary *proDic = [NSDictionary dictionaryWithObjectsAndKeys:key,@"promotionID",diffOfAPro,@"bookList", nil];
        [result addObject:proDic];
    }//for (id key in previousGoodList)
    return [result copy];
}

- (NSArray*)getSubmitList {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id key in self.promotionGoods) {
        NSMutableArray *isbns = [[NSMutableArray alloc] init];
        NSArray *goods = self.promotionGoods[key];
        for (NSInteger i = 0; i < goods.count; ++ i) {
            GoodModel *item = (GoodModel*)goods[i];
            if (item.isSelected) {
                [isbns addObject:item.bookISBN];
            }
        }
        NSDictionary *prodiff = [[NSDictionary alloc] initWithObjectsAndKeys:key,@"promotionID",isbns,@"bookList", nil];
        [result addObject:prodiff];
    }
    return [result copy];
}

//根据数据的选择状态返回待删除数据
- (NSArray*)findDeletingList {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id key in self.promotionGoods) {
        NSMutableArray *isbns = [[NSMutableArray alloc] init];
        NSArray *goods = self.promotionGoods[key];
        for (NSInteger i = 0; i < goods.count; ++ i) {
            GoodModel *item = (GoodModel*)goods[i];
            if (item.isSelected) {
                [isbns addObject:item.bookISBN];
            }
        }
        NSDictionary *prodiff = [[NSDictionary alloc] initWithObjectsAndKeys:key,@"promotionID",isbns,@"bookList", nil];
        [result addObject:prodiff];
    }
    return [result copy];

}

- (void)proccess:(NSArray*)result withSubmitedList:(NSArray*)submitList {
    for (id obj in result) {
        if ([[obj objectForKey:@"submitOrderID"] isEqualToString:@"3"]) {
            //提交成功
            NSString *promotionID = [obj objectForKey:@"promotionID"];
            NSArray *goods;
            for (id proGoods in lastSubmitList) {
                if ([[proGoods objectForKey:@"promotionID"] isEqualToString:promotionID]) {
                    goods = [proGoods objectForKey:@"bookList"];
                }
            }
            NSString *submitOrderID = [obj objectForKey:@"submitOrderID"];
            //存储此submitOrder
            UserOderModel* uOder = [[UserOderModel alloc] init:submitOrderID with:goods inPromotion:promotionID];
            [[NSUserDefaults standardUserDefaults] setObject:uOder  forKey:submitOrderID];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

#pragma mark - CartCellDelegate协议中函数

-(void)addBtnClick:(UITableViewCell *)cell {
    NSIndexPath *index = [self.table indexPathForCell:cell];
    GoodModel *item = [self.promotionGoods[[self.allPromotion objectAtIndex:index.section]] objectAtIndex:index.row];
    int newAmout = [item.amout intValue] + 1;
    item.amout = [NSNumber numberWithInt:newAmout];
    [self calTotalPrice];
    [self.table reloadData];
}

-(void)minusBtnClick:(UITableViewCell *)cell {
    NSIndexPath *index = [self.table indexPathForCell:cell];
    NSMutableArray *goods = self.promotionGoods[[self.allPromotion objectAtIndex:index.section]];
    GoodModel *item = [goods objectAtIndex:index.row];
    int oldAmout = [item.amout intValue];
    if (oldAmout > 1) {
        int newAmout = oldAmout - 1;
        item.amout = [NSNumber numberWithInt:newAmout];
        [self calTotalPrice];
        [self.table reloadData];
    }
    else {
        if (goods.count == 1) {
            //此活动中只有一本书，而该书的数量为1，减少1后，从购物车中删除该活动
            NSString *pro = [self.allPromotion objectAtIndex:index.section];
            [self.allPromotion removeObject:pro];
            [self.promotionGoods removeObjectForKey:pro];
        }
        else {
//            删除该活动下的该书即可
            [goods removeObject:item];
        }
    }
    [self calTotalPrice];
    [self.table reloadData];
}

-(void)selectBtnClick:(UITableViewCell *)cell {
    NSIndexPath *index = [self.table indexPathForCell:cell];
    NSMutableArray *goods = self.promotionGoods[[self.allPromotion objectAtIndex:index.section]];
    GoodModel *item = [goods objectAtIndex:index.row];
    item.isSelected = !item.isSelected;
    [self calTotalPrice];
    [self.table reloadData];
}

#pragma mark -- 计算价格
-(void)calTotalPrice
{
    //遍历整个数据源，然后判断如果是选中的商品，就计算价格（单价 * 商品数量）
    allPrice = 0.0;
    for (id key in self.promotionGoods) {
        NSArray *goods = self.promotionGoods[key];
        for (id good in goods) {
            GoodModel *item = (GoodModel*)good;
            if (item.isSelected) {
                float bookprice = [item.bookPrice floatValue];
                allPrice += bookprice*[item.amout integerValue];
            }
        }
    }
    self.totalPrice.text = [NSString stringWithFormat:@"%.2f",allPrice];
}

#pragma mark - 按钮响应事件
- (IBAction)selectAll:(id)sender {
    self.isSelectedAll = !self.isSelectedAll;
    [self updateAllSelectState:self.isSelectedAll];
    if (self.isSelectedAll) {
        [self.selectAllBtn setImage:[UIImage imageNamed:@"select-sel"] forState:UIControlStateNormal];
    }
    else 
        [self.selectAllBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
     [self calTotalPrice];
    [self.table reloadData];
}



- (IBAction)changeCartState:(id)sender {
    self.isEditState = !self.isEditState;
    [self updateAllEditState:self.isEditState];
    if (self.isEditState) {
        self.editBtn.title = @"完成";
        self.deleteBtn.hidden = NO;
        self.submitBtn.hidden = YES;
        self.totalPrice.hidden = YES;
        self.totalPriceIndicate.hidden = YES;
        previousGoodList = [NSMutableDictionary dictionaryWithDictionary:self.promotionGoods];
        [self.table reloadData];
    }
    else {
        self.editBtn.title = @"编辑";
        self.deleteBtn.hidden = YES;
        self.submitBtn.hidden = NO;
        self.totalPrice.hidden = NO;
        self.totalPriceIndicate.hidden = NO;
        //编辑完成时，比较前后差异并提交给服务器
        NSArray *differce = [self comepare:self.promotionGoods withPrevious:previousGoodList];
        [self requestModifyCart:differce];
    }
    
}

- (IBAction)submit:(id)sender {
    lastSubmitList = [self getSubmitList];
    [self requestToSubmit:lastSubmitList];
}

- (IBAction)delete:(id)sender {
    NSArray *deleteList = [self findDeletingList];
    [self requestToDeleteInCart:deleteList];
}


#pragma mark -网络请求
- (void)requestModifyCart:(NSArray*)diff {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    appdele.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@/shopping/modify/",appdele.baseUrl];
    [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
    [appdele.manager POST:url parameters:diff success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //提交修改成功后就更新数据表
         [self calTotalPrice];
         [self.table reloadData];
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [hud hideAnimated:YES];
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"获取购物车列表失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             //提交失败的话，重新请求数据库获取购物车列表
             [self loadGoodsList];
         }];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
     }];
    
    
    appdele.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
}

- (void)requestToDeleteInCart:(NSArray*)deletingList {
    
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    appdele.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@/shopping/remove/",appdele.baseUrl];
    [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
    [appdele.manager POST:url parameters:deletingList success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //提交修改成功后就更新购物车
         [self calTotalPrice];
         [self.table reloadData];
     }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [hud hideAnimated:YES];
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"删除失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             //提交失败的话，重新请求数据库获取购物车列表
             [self loadGoodsList];
         }];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
     }];
    
    appdele.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    


}

-(void)requestToSubmit:(NSArray*)submitList {
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/order/submit/",appdele.baseUrl];
    appdele.manager.requestSerializer = [AFJSONRequestSerializer serializer];
 
    [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
    [appdele.manager POST:url parameters:submitList success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *status = [responseObject objectForKey:@"status"];
         if ([status isEqualToString:@"0"]) {
              //处理提交结果
             NSArray *data = [responseObject objectForKey:@"data"];
             [self proccess:data withSubmitedList:lastSubmitList];
             //提交修改成功后就更新购物车
             //            此时已提交成功的部分不会出现在购物车中
             [self loadGoodsList];
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
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             //提交失败的话，购物车数据不变
//             [self loadGoodsList];
         }];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
         
         
     }];
    appdele.manager.requestSerializer = [AFHTTPRequestSerializer serializer];

}

@end
