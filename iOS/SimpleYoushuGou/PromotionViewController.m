//
//  PromotionViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/25.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "PromotionViewController.h"
#import "searchResultTableViewController.h"
#import "ActivityListCell.h"
#import "Activity.h"
#import "AppDelegate.h"
#import "PromotionCell.h"
#import "WebViewController.h"
#import "PromotionDetailViewController.h"
//#import "PromotionCell.h"
@interface PromotionViewController ()<UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UISegmentedControl *ShopsSegment;
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic,strong) NSArray *promotionList;//所有促销活动集合
@property (nonatomic, strong) NSMutableDictionary *shopActivitys;//根据shop对促销活动进行了分类的集合
@property (nonatomic,strong) NSArray *promotionIds;//所有促销活动ID集合
@property (nonatomic,strong) NSArray *shopWithActivity;//所有包含有促销活动的商店名
@property (nonatomic,copy) NSString *currentShop;//当前展示的商店
@end

@implementation PromotionViewController

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.shopActivitys = [[NSMutableDictionary alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    [self GetPromotrion];
    [self initSearchBar];
    [self initSegmentCtl];
    self.table.delegate = self;
    self.table.dataSource = self;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [self.table reloadData];
//}
#pragma mark -- 初始化相关子视图

- (void)initSegmentCtl{
//    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:self.shopWithActivity];
//    [segmentedControl insertSegmentWithTitle:@"全部“" atIndex:0 animated:NO];
    segmentedControl.frame = CGRectMake(10.0, 74.0, 355, 20.0);
    NSInteger defaultSeletedIndex = [self.shopWithActivity indexOfObject:@"全部"];
    segmentedControl.selectedSegmentIndex = defaultSeletedIndex;//设置默认选择项索引
    self.currentShop = [self.shopWithActivity objectAtIndex:segmentedControl.selectedSegmentIndex];//同时设置对应的表格数据
    [segmentedControl addTarget:self action:@selector(selectShop:)  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
}

- (void)initSearchBar{
    UINavigationController* searchResultVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultVC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    //    self.definesPresentationContext = YES;
    CGRect frame = [self.view frame];
    self.searchController.searchBar.frame = CGRectMake(0,200,frame.size.width, 44.0);
    self.searchController.searchBar.placeholder = @"搜索促销活动或者书籍";
    self.definesPresentationContext = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.navigationItem.titleView = self.searchController.searchBar;
}
#pragma mark -- UISegmentedControl响应函数
-(void)selectShop:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    self.currentShop = [self.shopWithActivity objectAtIndex:Index];
    [self.table reloadData];
}
#pragma mark -- talbeView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.shopActivitys objectForKey:self.currentShop] count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(PromotionCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    BOOL nibsRegistered=NO;
//    if (!nibsRegistered) {
//        UINib *nib=[UINib nibWithNibName:@"ActivityListCell" bundle:nil];
//        [tableView registerNib:nib forCellReuseIdentifier:@"ActivityListCell"];
//        nibsRegistered=YES;
//    }
//    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityListCell"];
//    NSArray* activitys = [self.shopActivitys objectForKey:self.currentShop];
//    cell.activityName.text = [[activitys objectAtIndex:indexPath.row] valueForKey:@"activityName"];
//    cell.shopsHead.image = [UIImage imageNamed:@"Amazon"];
    
//    static NSString* cellId = @"CellForPromotion";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    // 为表格行定义一个静态字符串作为标示符
    static NSString* cellId = @"cellId";
    PromotionCell* cell = [tableView
                             dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[PromotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSArray* activitys = [self.shopActivitys objectForKey:self.currentShop];
    cell.activity = [activitys objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"Amazon"];
//    cell.textLabel.text = [[activitys objectAtIndex:indexPath.row] valueForKey:@"activityName"];
    cell.textLabel.text = [cell.activity valueForKey:@"activityName"];
    cell.detailTextLabel.text = @"我听过空境的回忆，雨水浇绿孤山岭，听过被没听过你；我抓住散落的欲望，缱绻的馥郁让我紧张，我抓住时间的假想，没抓住你";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath
{
    PromotionCell *cell= (PromotionCell*)[tableView cellForRowAtIndexPath:indexPath];
    ActivityType type = cell.activity.activityType;
    
    
    switch (type) {
        case GroupBuy:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PromotionDetailViewController* detailVC = [storyboard instantiateViewControllerWithIdentifier:@"PromotionDetailViewController"];
            detailVC.promotrion = cell.activity;
            [self.navigationController pushViewController:detailVC animated:NO];
        }
            break;
//        case PartDiscout:
//            break;
        default:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WebViewController* webVC = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            webVC.urlStr = cell.activity.activityUrl;
            webVC.title = cell.activity.activityName;
            [self.navigationController pushViewController:webVC animated:NO];
        }
           
            
            break;
    }
}

#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

// Called when the search bar becomes first responder
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    // Set searchString equal to what's typed into the searchbar
    NSString *searchString = self.searchController.searchBar.text;
    // If searchResultsController
    if (self.searchController.searchResultsController) {
        
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        // Present SearchResultsTableViewController as the topViewController
        searchResultTableViewController* vc = (searchResultTableViewController *)navController.topViewController;
        // Update searchResults
        [self filteredContentBySubString:searchString];
        vc.searchResults = self.searchResults;
        vc.searchStr = searchString;
        
        // And reload the tableView with the new data
        [vc.tableView reloadData];
    }
}
//- (void)searchBar:(UISearchBar *)searchBar
//    textDidChange:(NSString *)searchText
//{
//    NSLog(@"text change");
//}




#pragma mark -- 内部函数
//- (NSArray*)getActivityName
//{
//    return [NSArray arrayWithObjects:@"全部", @"京东", @"当当", nil];
//}
- (void)GetPromotrion
{
    //    self.promotionList = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"京东少儿经管原版专场200-100",@"promotionName",@"http://sale.jd.com/act/QRZ4SIHq7PrMh.html?cu=true&utm_source=www.wgmiji.com&utm_medium=tuiguang&utm_campaign=t_4515484_&utm_term=bd6bbadd1701455685fa776b36b34871",@"link", nil],@"Gb京东1",
    //                          [NSMutableDictionary dictionaryWithObjectsAndKeys: @"京东二十余万图书每100-30",@"promotionName",@"http://sale.jd.com/act/JIBcYK0CvDUT.html?cu=true&utm_source=www.wgmiji.com&utm_medium=tuiguang&utm_campaign=t_4515484_&utm_term=eb1f2268332042acb57d93f0fff24783",@"link", nil],@"Gb京东2",
    //                          [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"亚马逊22万中文书200-50",@"promotionName",@"https://www.amazon.cn/b?tag=dp-23&node=1815993071",@"link", nil],@"Gb亚马逊1",
    //                          [NSMutableDictionary dictionaryWithObjectsAndKeys: @"微信领券满200-80、150-50",@"promotionName",@"https://wqs.jd.com/event/juhui/66top/index.shtml?mktid=131&shopid=333099&enc=S1Is1CcT1Xf3z64JJ70MtXl_1tR1rAYXx6-pze8w_jHfmfLMYYmTiqim_KgWGDwtD35Fn01TZEBffxT6WoWfuM2xY2Eukxe_w4pSxRF5dzI=&tk=08b50c0ab2588709185af5e12eed313a&share=0&fs=1&gt=1466072339&v=1&cu=true&utm_source=kong&utm_medium=tuiguang&utm_campaign=t_2006398888_&utm_term=6844db2b3bf549f68823e99f63c18bdd",@"link", nil],@"Gb京东1",
    //                          [NSMutableDictionary dictionaryWithObjectsAndKeys: @"当当万种图书200-100",@"promotionName",@"http://promo.dangdang.com/subject.php?pm_id=3310662&_ddclickunion=P-295132-121209_64_0__1|ad_type=0|sys_id=1#dd_refer=http%3A%2F%2Fc.duomai.com%2Ftrack.php%3Fsite_id%3D121209%26aid%3D64%26euid%3D%26t%3Dhttp%253a%252f%252fpromo.dangdang.com%252fsubject.php%253fpm_id%253d3310662",@"link", nil],@"Gb当当1",
    //                          [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"当当教育类100-30 300-100",@"promotionName",@"wwwGbDd2",@"link", nil],@"Gb当当2",
    //                          [[NSMutableDictionary alloc] initWithObjectsAndKeys:  @"亚马逊4万原版书满300减150",@"promotionName",@"https://www.amazon.cn/b?tag=dp-23&node=1816777071",@"link", nil],@"Gb亚马逊2",
    //                          [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"亚马逊电子书包月服务",@"promotionName",@"https://www.amazon.cn/gp/kindle/ku/sign-up/ref=sr_ku_lm?tag=dp-23&ie=UTF8&qid=1455875453",@"link", nil],@"Pb亚马逊1",
    //                          [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"武侯区云驭风书店全场满100减50、满200减100 ",@"promotionName",@"https://yyf365.taobao.com/shop/view_shop.htm?user_number_id=1117784433&ali_trackid=2%3Amm_32462830_4340057_14662838%3A1466817969_251_1477673269&upsid=4d37913cbc26033287160f6be8a0d226&clk1=4d37913cbc26033287160f6be8a0d226",@"link", nil],@"Gb淘宝1",
    //                          [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"中图万种图书150-70",@"promotionName",@"http://www.bookschina.com/subject/160622myear.aspx",@"link", nil],@"Gb中图1",
    //                          nil];
    

    self.promotionList = [NSMutableArray arrayWithObjects:
                          [[Activity alloc] init:@"Gb京东1" withName:@"京东少儿经管原版专场200-100" activiType:GroupBuy  urlString:@"http://sale.jd.com/act/QRZ4SIHq7PrMh.html?cu=true&utm_source=www.wgmiji.com&utm_medium=tuiguang&utm_campaign=t_4515484_&utm_term=bd6bbadd1701455685fa776b36b34871"]
                          , [[Activity alloc] init:@"Gb京东2" withName:@"京东二十余万图书每100-30" activiType:GroupBuy urlString:@"http://sale.jd.com/act/JIBcYK0CvDUT.html?cu=true&utm_source=www.wgmiji.com&utm_medium=tuiguang&utm_campaign=t_4515484_&utm_term=eb1f2268332042acb57d93f0fff24783"]
                          ,[[Activity alloc] init:@"Gb亚马逊1" withName:@"亚马逊22万中文书200-50" activiType:GroupBuy  urlString:@"https://www.amazon.cn/b?tag=dp-23&node=1815993071"]
                          ,[[Activity alloc] init:@"Gb京东3" withName:@"微信领券满200-80、150-50" activiType:Other urlString:@"https://wqs.jd.com/event/juhui/66top/index.shtml?mktid=131&shopid=333099&enc=S1Is1CcT1Xf3z64JJ70MtXl_1tR1rAYXx6-pze8w_jHfmfLMYYmTiqim_KgWGDwtD35Fn01TZEBffxT6WoWfuM2xY2Eukxe_w4pSxRF5dzI=&tk=08b50c0ab2588709185af5e12eed313a&share=0&fs=1&gt=1466072339&v=1&cu=true&utm_source=kong&utm_medium=tuiguang&utm_campaign=t_2006398888_&utm_term=6844db2b3bf549f68823e99f63c18bdd"]
                          ,[[Activity alloc] init:@"Gb当当1" withName:@"当当万种图书200-100" activiType:GroupBuy urlString:@"http://promo.dangdang.com/subject.php?pm_id=3310662&_ddclickunion=P-295132-121209_64_0__1|ad_type=0|sys_id=1#dd_refer=http%3A%2F%2Fc.duomai.com%2Ftrack.php%3Fsite_id%3D121209%26aid%3D64%26euid%3D%26t%3Dhttp%253a%252f%252fpromo.dangdang.com%252fsubject.php%253fpm_id%253d3310662"]
                          ,[[Activity alloc] init:@"Gb当当2" withName:@"20万图书满100减30 200减60 300减100" activiType:GroupBuy  urlString:@"http://book.dangdang.com/20160603_35pz?_ddclickunion=P-295132-121209_64_0__1|ad_type=0|sys_id=1#dd_refer=http%3A%2F%2Fc.duomai.com%2Ftrack.php%3Fsite_id%3D121209%26aid%3D64%26euid%3D%26t%3Dhttp%253a%252f%252fbook.dangdang.com%252f20160603_35pz"]
                          ,[[Activity alloc] init:@"Gb亚马逊2" withName:@"亚马逊4万原版书满300减150" activiType:GroupBuy  urlString:@"https://www.amazon.cn/b?tag=dp-23&node=1816777071"]
                          ,[[Activity alloc] init:@"Pb亚马逊1" withName:@"亚马逊电子书包月服务" activiType:Other urlString:@"https://www.amazon.cn/gp/kindle/ku/sign-up/ref=sr_ku_lm?tag=dp-23&ie=UTF8&qid=1455875453"]
                          ,[[Activity alloc] init:@"Gb淘宝1" withName:@"武侯区云驭风书店全场满100减50、满200减100 " activiType:Other urlString:@"https://yyf365.taobao.com/shop/view_shop.htm?user_number_id=1117784433&ali_trackid=2%3Amm_32462830_4340057_14662838%3A1466817969_251_1477673269&upsid=4d37913cbc26033287160f6be8a0d226&clk1=4d37913cbc26033287160f6be8a0d226"]
                          ,[[Activity alloc] init:@"Gb中图1" withName:@"中图万种图书150-70" activiType:GroupBuy  urlString:@"http://www.bookschina.com/subject/160622myear.aspx"]
                          ,nil];
    [self classifyActivity];
    
}

- (void)classifyActivity{
    AppDelegate* appdele = [UIApplication sharedApplication].delegate;
    NSArray* allShop = [appdele.shopList allKeys];
    [self.shopActivitys setObject:self.promotionList forKey:@"全部"];
    for (id shop in allShop) {
        NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K CONTAINS %@",@"activityId",shop];
        NSArray* filterResult = [self.promotionList filteredArrayUsingPredicate:pred];
        if (filterResult.count) {
            [self.shopActivitys setObject:filterResult forKey:shop];
        }
    }
    self.shopWithActivity = [self.shopActivitys allKeys];
}
- (void)filteredContentBySubString:(NSString *)subStr
{
    
        if ([subStr  isEqual: @""]) {
    
            // If empty the search results are the same as the original data
            self.searchResults = [self.promotionList mutableCopy];
        } else {
//            NSPredicate* pred = [NSPredicate predicateWithFormat:
//                                 @"%K CONTAINS[c] %@" ,@"activityName",subStr];
            NSPredicate* pred = [NSPredicate predicateWithFormat:
                                 @"%K CONTAINS %@" ,@"activityName",subStr];
            // 使用谓词过滤NSArray
            self.searchResults = [NSMutableArray arrayWithArray:[self.promotionList filteredArrayUsingPredicate:pred]];
        }
}








@end
