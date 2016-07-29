//
//  GroupViewController.m
//  YouShuGou
//
//  Created by 苏丽荣 on 16/7/9.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "GroupViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "ValidCombineOrder.h"
#import "GroupBaseInfoCell.h"
#import "UserOrderDetail.h"
#import "CoderUserDetailController.h"

@interface GroupViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *hud;
    MBProgressHUD *removeHud;
     UISegmentedControl *segmentedControl;
}
//ValidCombineOrders数组
@property (nonatomic ,strong) NSArray* VoderList;

//ValidCombineOrders数组,存放状态为6的订单,拼成功的拼单
@property (nonatomic ,strong) NSMutableArray *succeedVoder;
//ValidCombineOrders数组,存放状态为4，5的订单,需要用户确认是否接受
@property (nonatomic ,strong) NSMutableArray *appenVorder;
//根据segement选择的值二变化的当前展示的list
@property (nonatomic ,strong) NSMutableArray *displayOrderList;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.table.delegate = self;
    self.table.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initSegmentCtl];
    // Do any additional setup after loading the view.
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadCOderList];
    }];
    // 马上进入刷新状态
    [self.table.mj_header beginRefreshing];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 获取数据源

- (void)loadCOderList {
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    hud.label.text = NSLocalizedString(@"加载团列表...", @"HUD loading title");

    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    if (appdele.OnLineTest) {
        [self getCOderList];
    }
    else {
        [self getCOderListLocally];
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

- (void) getCOderList {
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/order/combine/list/",appdele.baseUrl];
    [appdele.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userCookie"] forHTTPHeaderField:@"Cookie"];
    [self printSet: appdele.manager.responseSerializer.acceptableContentTypes];
    
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




- (void) getCOderListLocally {
    // 获取JSON文件所在的路径
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"GroupList"  ofType:@"json"];
    // 读取jsonPath对应文件的数据
    NSData* data = [NSData dataWithContentsOfFile:jsonPath];
    // 调用JSONKit为NSData扩展的objectFromJSONData方法解析JSON数据
    NSArray *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [self formOrderList:responseObject];
    [hud hideAnimated:YES];
}

- (void)formOrderList:(NSArray*)arr {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id item in arr) {
        ValidCombineOrder *VcOder = [[ValidCombineOrder alloc] initWihtDictionary:item];
        [result addObject:VcOder];
    }
    self.VoderList = [result copy];
    [self classifyOrder];
    [self.table reloadData];
    [self.table.mj_header endRefreshing];
    [hud hideAnimated:YES];
}

#pragma mark - 数据分类显示


- (void)initSegmentCtl{
    NSArray *titles = [NSArray arrayWithObjects: @"组团中",@"已成团",nil];
    segmentedControl = [[UISegmentedControl alloc]initWithItems:titles];
    segmentedControl.frame = CGRectMake(15.0, 74.0,345 , 30.0);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    self.displayOrderList = self.appenVorder;
    [segmentedControl addTarget:self action:@selector(selectOrderType:)  forControlEvents:UIControlEventValueChanged];
    //        self.navigationItem.titleView = segmentedControl;
    //    self.table.tableHeaderView = segmentedControl;
    [self.view addSubview:segmentedControl];
    [self.table.mj_header beginRefreshing];
    
}


//根据状态，对orderList进行分类
- (void)classifyOrder {
    self.succeedVoder = [[NSMutableArray alloc] init];
    self.appenVorder = [[NSMutableArray alloc] init];

    for (id obj in self.VoderList) {
        NSNumber *status = [obj valueForKey:@"currentStatus"];
        NSInteger state = [status intValue];
        
    
        if (state == 4 || state == 5) {
            [self.appenVorder addObject:obj];
            
        }
        else if (state == 6) {
            [self.succeedVoder addObject:obj];
        }
    }
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    self.displayOrderList = self.appenVorder;
    
}

- (void)selectOrderType:(id)sender {
    UISegmentedControl *Seg = (UISegmentedControl*)sender;
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            self.displayOrderList = self.appenVorder;
            break;
        case 1:
            self.displayOrderList = self.succeedVoder;
            break;
               default:
        self.displayOrderList = self.appenVorder;
            break;
    }
    [self.table reloadData];
}


#pragma mark - tableView datasource 和tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 124;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    NSInteger result = self.VoderList.count;
    NSInteger result = self.displayOrderList.count;
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger result = [[self.displayOrderList[section] valueForKey:@"members"] count] + 1;
    return  result;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL nibsRegistered=NO;
    static NSString *cellID = @"GroupBaseInfoCell";
    if (!nibsRegistered) {
        UINib *nib=[UINib nibWithNibName:@"GroupBaseInfoCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        nibsRegistered=YES;
    }
    GroupBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    ValidCombineOrder *VcOrder = self.displayOrderList[indexPath.section];
    switch (indexPath.row) {
        case 0:
        {
            UserOrderDetail* uOrderDetail = VcOrder.gameLeader;
            [cell fillContent:uOrderDetail];
            cell.userName.backgroundColor = [UIColor blueColor];
        }
            break;
            
        default:
        {
            NSInteger ind = indexPath.row - 1;
            UserOrderDetail* uOrderDetail = VcOrder.members[ind];
            [cell fillContent:uOrderDetail];
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath
{
    
    ValidCombineOrder *VcOrder = self.displayOrderList[indexPath.section];
    UserOrderDetail *oDetail;
    switch (indexPath.row) {
        case 0:
            oDetail = VcOrder.gameLeader;
            break;
            
        default:
        {
            NSInteger ind = indexPath.row - 1;
            oDetail = VcOrder.members[ind];
        }
            break;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CoderUserDetailController* detailVC = [storyboard instantiateViewControllerWithIdentifier:@"CoderUserDetailController"];
    detailVC.orderDetail = oDetail;

    [self.navigationController pushViewController:detailVC animated:NO];
}



//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    NSString *title = [self.orderList[section] valueForKey:@"submitOrderID"];
//    return title;
//}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ValidCombineOrder *VcOrder = self.VoderList[section];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0,0, 375, 40)];
//
    UILabel *orderID = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 375, 20)];
    orderID.text = VcOrder.combineOrderID;
    [header addSubview:orderID];
//
//    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,20, 150, 20)];
//    statusLabel.text = [NSString stringWithFormat:@"status:%@",VcOrder.currentStatus];
//    [header addSubview:statusLabel];
    return header;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end