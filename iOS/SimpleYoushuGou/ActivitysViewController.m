//
//  ActivitysViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/23.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//
#import "AppDelegate.h"
#import "ActivitysViewController.h"
#import "searchResultTableViewController.h"
#import "SlideTabBarView.h"
#import "ActivityListCell.h"
#import "Activity.h"

@interface ActivitysViewController ()<UISearchResultsUpdating,SlideTabBarViewDelegate,SlideTabBarViewDataSource>
@property (nonatomic,strong) SlideTabBarView* slideBarView;
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic,strong) NSArray *promotionList;
@property (nonatomic, strong) NSMutableDictionary *shopActivitys;
@property (nonatomic,strong) NSArray *promotionIds;
@property (nonatomic,strong) NSArray *shopWithActivity;
@end

@implementation ActivitysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.shopActivitys = [[NSMutableDictionary alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    [self GEtPromotrion];
    [self initSlideBarView];
    [self initSearchBar];
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 初始化相关子视图
- (void)initSlideBarView{
    NSInteger lowerBarHeight =  self.tabBarController.tabBar.frame.size.height;
    NSInteger higherBarHeight =  self.navigationController.navigationBar.frame.size.height;
    NSInteger statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    [self.view setBackgroundColor:[UIColor grayColor]];
    //    self.navigationController.navigationBar.hidden = YES;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    
    NSInteger slideBarViewHeight = frame.size.height - (higherBarHeight);
    CGRect slideBarViewFrame = CGRectMake(0,0,frame.size.width,slideBarViewHeight);
    
    self.slideBarView = [[SlideTabBarView alloc] initWithFrame:slideBarViewFrame withDelegate:self];
    
    [self.slideBarView setColor:[UIColor purpleColor] AtIndex:2];
    [self.view addSubview:self.slideBarView];
}

- (void)initSearchBar{
    UINavigationController* searchResultVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultVC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    //    self.definesPresentationContext = YES;
    CGRect frame = [self.view frame];
    self.searchController.searchBar.frame = CGRectMake(0,200,frame.size.width, 44.0);
    self.definesPresentationContext = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.navigationItem.titleView = self.searchController.searchBar;
}
#pragma mark -- SlideTabBarViewDelegate,SlideTabBarViewDataSource
- (CGFloat) heightForTopBar
{
    return 30;
}
- (NSArray*) titlesForTapButton
{
//    return [NSArray arrayWithObjects:@"全部", @"京东", @"当当", nil];
    return self.shopWithActivity;
}

- (UITableView*) tableForPage:(NSInteger)page withFrame:(CGRect)frame {
    
    //    NSLog(@"tableForPage:%@",NSStringFromCGRect(frame));
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
    return tableView;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView atPage:(NSInteger)page{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section atPage:(NSInteger)page{
    NSInteger rowAmout = [[self.shopActivitys objectForKey:[self.shopWithActivity objectAtIndex:page]] count];
    return rowAmout;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath atPage:(NSInteger)page
{
    return 100;
}

-(UITableViewCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath atPage:(NSInteger)page
{
    BOOL nibsRegistered=NO;
    if (!nibsRegistered) {
        UINib *nib=[UINib nibWithNibName:@"ActivityListCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"ActivityListCell"];
        nibsRegistered=YES;
    }
    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityListCell"];
    NSString* shop = [self.shopWithActivity objectAtIndex:page];
    NSLog(@"%@,activity amout:%ld",shop,[[self.shopActivitys objectForKey:shop] count]);
    NSArray* activitys = [NSArray arrayWithArray:[self.shopActivitys objectForKey:shop]];
    cell.activityName.text = [[activitys objectAtIndex:indexPath.row] valueForKey:@"activityName"];
    cell.shopsHead.image = [UIImage imageNamed:@"Amazon"];
    cell.urlStr = [[activitys objectAtIndex:indexPath.row] valueForKey:@"activityUrl"];
    return cell;

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
        //        [self PrintArray:self.searchResults];
        
        // And reload the tableView with the new data
        [vc.tableView reloadData];
    }
}



#pragma mark -- 内部函数
//- (NSArray*)getActivityName
//{
//    return [NSArray arrayWithObjects:@"全部", @"京东", @"当当", nil];
//}
- (void)GEtPromotrion
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
 
////    self.promotionList = [NSMutableArray arrayWithObjects:
//                          [[Activity alloc] init:@"Gb京东1" withName:@"京东少儿经管原版专场200-100" urlString:@"http://sale.jd.com/act/QRZ4SIHq7PrMh.html?cu=true&utm_source=www.wgmiji.com&utm_medium=tuiguang&utm_campaign=t_4515484_&utm_term=bd6bbadd1701455685fa776b36b34871"]
//                          , [[Activity alloc] init:@"Gb京东2" withName:@"京东二十余万图书每100-30" urlString:@"http://sale.jd.com/act/JIBcYK0CvDUT.html?cu=true&utm_source=www.wgmiji.com&utm_medium=tuiguang&utm_campaign=t_4515484_&utm_term=eb1f2268332042acb57d93f0fff24783"]
//                          ,[[Activity alloc] init:@"Gb亚马逊1" withName:@"亚马逊22万中文书200-50" urlString:@"https://www.amazon.cn/b?tag=dp-23&node=1815993071"]
//                          ,[[Activity alloc] init:@"Gb京东3" withName:@"微信领券满200-80、150-50" urlString:@"https://wqs.jd.com/event/juhui/66top/index.shtml?mktid=131&shopid=333099&enc=S1Is1CcT1Xf3z64JJ70MtXl_1tR1rAYXx6-pze8w_jHfmfLMYYmTiqim_KgWGDwtD35Fn01TZEBffxT6WoWfuM2xY2Eukxe_w4pSxRF5dzI=&tk=08b50c0ab2588709185af5e12eed313a&share=0&fs=1&gt=1466072339&v=1&cu=true&utm_source=kong&utm_medium=tuiguang&utm_campaign=t_2006398888_&utm_term=6844db2b3bf549f68823e99f63c18bdd"]
//                          ,[[Activity alloc] init:@"Gb当当1" withName:@"当当万种图书200-100" urlString:@"http://promo.dangdang.com/subject.php?pm_id=3310662&_ddclickunion=P-295132-121209_64_0__1|ad_type=0|sys_id=1#dd_refer=http%3A%2F%2Fc.duomai.com%2Ftrack.php%3Fsite_id%3D121209%26aid%3D64%26euid%3D%26t%3Dhttp%253a%252f%252fpromo.dangdang.com%252fsubject.php%253fpm_id%253d3310662"]
//                          ,[[Activity alloc] init:@"wwwGb当当2" withName:@"20万图书满100减30 200减60 300减100  " urlString:@"http://book.dangdang.com/20160603_35pz?_ddclickunion=P-295132-121209_64_0__1|ad_type=0|sys_id=1#dd_refer=http%3A%2F%2Fc.duomai.com%2Ftrack.php%3Fsite_id%3D121209%26aid%3D64%26euid%3D%26t%3Dhttp%253a%252f%252fbook.dangdang.com%252f20160603_35pz"]
//                          ,[[Activity alloc] init:@"Gb亚马逊2" withName:@"亚马逊4万原版书满300减150" urlString:@"https://www.amazon.cn/b?tag=dp-23&node=1816777071"]
//                          ,[[Activity alloc] init:@"Pb亚马逊1" withName:@"亚马逊电子书包月服务" urlString:@"https://www.amazon.cn/gp/kindle/ku/sign-up/ref=sr_ku_lm?tag=dp-23&ie=UTF8&qid=1455875453"]
//                          ,[[Activity alloc] init:@"Gb淘宝1" withName:@"武侯区云驭风书店全场满100减50、满200减100 " urlString:@"https://yyf365.taobao.com/shop/view_shop.htm?user_number_id=1117784433&ali_trackid=2%3Amm_32462830_4340057_14662838%3A1466817969_251_1477673269&upsid=4d37913cbc26033287160f6be8a0d226&clk1=4d37913cbc26033287160f6be8a0d226"]
//                          ,[[Activity alloc] init:@"Gb中图1" withName:@"中图万种图书150-70" urlString:@"http://www.bookschina.com/subject/160622myear.aspx"]
//                          ,nil];
    [self classifyActivity];
    
}

- (void)classifyActivity{
     AppDelegate* appdele = [UIApplication sharedApplication].delegate;
    NSArray* allShop = [appdele.shopList allKeys];
    
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
    
    //    if ([subStr  isEqual: @""]) {
    //
    //        // If empty the search results are the same as the original data
    //        self.searchResults = [self.promotionList mutableCopy];
    //    } else {
    //        NSPredicate* pred = [NSPredicate predicateWithFormat:
    //                             @"SELF CONTAINS[c] %@" , subStr];
    //        // 使用谓词过滤NSArray
    //        self.searchResults = [NSMutableArray arrayWithArray:[self.promotionList filteredArrayUsingPredicate:pred]];
    //        //        [self PrintArray:self.searchResults];
    //    }
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
