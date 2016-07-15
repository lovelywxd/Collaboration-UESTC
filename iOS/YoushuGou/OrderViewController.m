//
//  OrderViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "OrderViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "SubmitOrderModel.h"
#import "OrderCell.h"

@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *hud;
    MBProgressHUD *removeHud;
    UISegmentedControl *segmentedControl;

}
//SubmitOrderModel数组，服务器存储的所有用户的相关订单
@property (nonatomic ,copy) NSMutableArray *orderList;
//SubmitOrderModel数组,存放状态为3,5的订单,拼单中的订单
@property (nonatomic ,strong) NSMutableArray *calculatingList;
//SubmitOrderModel数组,存放状态为4的订单,需要用户确认是否接受
@property (nonatomic ,strong) NSMutableArray *needProcessingList;
//SubmitOrderModel数组,存放状态为6的订单,已成功拼单的订单
@property (nonatomic ,strong) NSMutableArray *successfulList;
//根据segement选择的值二变化的当前展示的list
@property (nonatomic ,strong) NSMutableArray *displayOrderList;

//SubmitOrderModel数组,存放状态为7，或者2的订单用户可选择回收这些订单，也就是请求服务器继续拼购他们
@property (nonatomic ,strong) NSMutableArray *recyclealbleList;
//SubmitOrderModel数组,存放状态为8的失效订单
@property (nonatomic ,strong) NSMutableArray *InvalidList;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.delegate = self;
    self.table.dataSource = self;
    // Do any additional setup after loading the view.
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
   
    self.title = @"我的订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
     __unsafe_unretained __typeof(self) weakSelf = self;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadOrderList];
    }];
     [self initSegmentCtl];
    // 马上进入刷新状态
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareProperty {
    
}

- (void)initSegmentCtl{
    NSArray *titles = [NSArray arrayWithObjects: @"拼单中",@"待处理",@"已拼单",@"可回收",@"已失效",nil];
    segmentedControl = [[UISegmentedControl alloc]initWithItems:titles];
    segmentedControl.frame = CGRectMake(15.0, 74.0,345 , 30.0);
    segmentedControl.selectedSegmentIndex = 1;//设置默认选择项索引
    self.displayOrderList = self.needProcessingList;
    [segmentedControl addTarget:self action:@selector(selectOrderType:)  forControlEvents:UIControlEventValueChanged];
//        self.navigationItem.titleView = segmentedControl;
//    self.table.tableHeaderView = segmentedControl;
    [self.view addSubview:segmentedControl];
    [self.table.mj_header beginRefreshing];
    
}

#pragma mark - 获取数据源

- (void)SimplyLoadLsit {
    [self getOrderList];
}

- (void)loadOrderList {
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    hud.label.text = NSLocalizedString(@"加载订单列表...", @"HUD loading title");
    
    [self prepareProperty];
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    if (appdele.OnLineTest) {
        [self getOrderList];
    }
    else {
        [self getOrderLocally];
    }
    [self.table reloadData];
}
- (void) printSet:(NSSet*)aSet {
    NSLog(@"count is:%ld",aSet.count);
    NSEnumerator *enumerator = [aSet objectEnumerator];
    id value;
    while ((value = [enumerator nextObject])) {
        NSLog(@"%@,",value);
    }
}

- (void) getOrderList {
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/order/submit/list/",appdele.baseUrl];
    [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
//    appdele.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
//       appdele.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"text/plain",nil];
//    [self printSet: appdele.manager.responseSerializer.acceptableContentTypes];
    
    [appdele.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self formOrderList:responseObject];
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


- (void) getOrderLocally {
    // 获取JSON文件所在的路径
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"orderList"  ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    NSArray *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
     [self formOrderList:responseObject];
     [hud hideAnimated:YES];
}

- (void)formOrderList:(NSArray*)arr {
    [self.table.mj_header endRefreshing];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id item in arr) {
        SubmitOrderModel *SOder = [[SubmitOrderModel alloc] initWithDictionary:item];
        [result addObject:SOder];
    }
    self.orderList = [result mutableCopy];
//    NSArray *temp = [self.orderList copy];
    [self classifyOrder];
    [self.table reloadData];
    [hud hideAnimated:YES];
}

//根据状态，对orderList进行分类
- (void)classifyOrder {
    self.calculatingList = [[NSMutableArray alloc] init];
    self.calculatingList = [[NSMutableArray alloc] init];
    self.needProcessingList = [[NSMutableArray alloc] init];
    self.successfulList = [[NSMutableArray alloc] init];
    self.recyclealbleList = [[NSMutableArray alloc] init];
    self.InvalidList = [[NSMutableArray alloc] init];
    for (id obj in self.orderList) {
        NSNumber *status = [obj valueForKey:@"currentStatus"];
        NSInteger state = [status intValue];

        
        if (state == 3 || state == 5) {
            [self.calculatingList addObject:obj];
        }
        else if (state == 4) {
            [self.needProcessingList addObject:obj];
            
        }
        else if (state == 6) {
            [self.successfulList addObject:obj];
        }
        else if (state == 7 || state == 2) {
            [self.recyclealbleList addObject:obj];
        }
        else if (state == 8) {
            [self.InvalidList addObject:obj];
        }

        
//        if ([status isEqualToString:@"3"] || [status isEqualToString:@"5"]) {
//            [self.calculatingList addObject:obj];
//        }
//        else if ([status isEqualToString:@"4"]) {
//            [self.needProcessingList addObject:obj];
//            
//        }
//        else if ([status isEqualToString:@"6"]) {
//            [self.successfulList addObject:obj];
//        }
//        else if ([status isEqualToString:@"7"] || [status isEqualToString:@"2"]) {
//            [self.recyclealbleList addObject:obj];
//        }
//        else if ([status isEqualToString:@"8"]) {
//            [self.InvalidList addObject:obj];
//        }
        
        
        
    }
    segmentedControl.selectedSegmentIndex = 1;//设置默认选择项索引
    self.displayOrderList = self.needProcessingList;
    
}


#pragma mark - tableView datasource 和tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 122;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.orderList.count;
     return self.displayOrderList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return  [[self.orderList[section] valueForKey:@"bookList"] count];
    return  [[self.displayOrderList[section] valueForKey:@"bookList"] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL nibsRegistered=NO;
    static NSString *cellID = @"OrderCell";
    if (!nibsRegistered) {
        UINib *nib=[UINib nibWithNibName:@"OrderCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        nibsRegistered=YES;
    }
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
//    SubmitOrderModel *Soder = self.orderList[indexPath.section];
    SubmitOrderModel *Soder = self.displayOrderList[indexPath.section];
    
    NSArray *goods = Soder.bookList;
    Good* good = goods[indexPath.row];
    [cell fillContent:good];
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString *title = [self.orderList[section] valueForKey:@"submitOrderID"];
    NSString *title = [self.displayOrderList[section] valueForKey:@"submitOrderID"];
    return title;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    SubmitOrderModel *SoOder = self.orderList[section];
    SubmitOrderModel *SoOder = self.displayOrderList[section];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0,0, 375, 40)];
    
    UILabel *orderID = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 375, 20)];
    orderID.text = SoOder.submitOrderID;
    [header addSubview:orderID];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,20, 150, 20)];
    statusLabel.text = [NSString stringWithFormat:@"status:%@",SoOder.currentStatus];
    [header addSubview:statusLabel];
    return header;
}

//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    SubmitOrderModel *SoOder = self.orderList[section];
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0,0, 375, 40)];
//
//    
//    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,20, 150, 20)];
//    orderID.text = [NSString stringWithFormat:@"status%@",SoOder.currentStatus];
//    [header addSubview:statusLabel];
//    return header;
//
//}




//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}

- (void)selectOrderType:(id)sender {
    UISegmentedControl *Seg = (UISegmentedControl*)sender;
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            self.displayOrderList = self.calculatingList;
            break;
        case 1:
            self.displayOrderList = self.needProcessingList;
            break;
        case 2:
            self.displayOrderList = self.successfulList;
            break;
        case 3:
            self.displayOrderList = self.recyclealbleList;
            break;
        case 4:
            self.displayOrderList = self.InvalidList;
            break;
        default:
            self.displayOrderList = self.needProcessingList;
            break;
    }
    [self.table reloadData];
}
- (IBAction)Recycled:(id)sender {
}
@end
