//
//  tempHomeTableViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/21.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "tempHomeTableViewController.h"
#import "searchResultTableViewController.h"
@interface tempHomeTableViewController ()<UISearchResultsUpdating>
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;
//@property (nonatomic,strong) NSMutableArray *tableData;
@property (nonatomic,strong) NSMutableDictionary *promotionList;
@property (nonatomic,strong) NSArray *promotionIds;
@end

@implementation tempHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.promotionList = [NSMutableArray arrayWithObjects:@"疯狂Java讲义",
//                      @"轻量级Java EE企业应用实战",
//                      @"疯狂Android讲义",
//                      @"疯狂Ajax讲义",
//                      @"疯狂HTML5/CSS3/JavaScript讲义",
//                      @"疯狂iOS讲义",
//                      @"疯狂XML讲义",
//                      @"经典Java EE企业应用实战"
//                      @"Java入门与精通",
//                      @"Java基础教程",
//                      @"学习Java",
//                      @"Objective-C基础" ,
//                      @"Ruby入门与精通",
//                      @"iOS开发教程" , nil];
    [self GEtPromotrion];
    UINavigationController* searchResultVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultVC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    //    self.definesPresentationContext = YES;
    CGRect frame = [self.view frame];
    self.searchController.searchBar.frame = CGRectMake(0,
                                                       200,
                                                       frame.size.width, 44.0);
    
    //    [self.searchController.view setFrame:CGRectMake(0, 400, 300, 700)];
    //    [self.view addSubview:self.searchController.view];
    [self.searchController.view setBackgroundColor:[UIColor blueColor]];
    if (self.navigationController == nil) {
        NSLog(@"self.navigationController == nil");
    }
    else if(self.navigationController.navigationItem == nil)
    {
        NSLog(@"self.navigationController.navigationItem == nil");
    }
    //    if([self.searchController.searchBar superview] == self.)
    //    {
    //        NSLog(@"navigationBar");
    //    }
    
//    self.navigationItem.titleView = self.searchController.searchBar;
    self.tableView.tableHeaderView = self.searchController.searchBar;
//    self.tableView.style = UITableViewStyleGrouped;
    
    NSString *pos = NSStringFromCGRect(self.searchController.searchBar.frame);
    NSLog(@"%@",pos);
    ////    [self.view addSubview:self.searchController.searchBar];
    //     NSLog(@"navigationBar:%@",NSStringFromCGRect(self.navigationBar.frame));
        self.title = @"主页";
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row_amout;
    switch (section) {
        case 0:
            row_amout = 1;
            break;
        default:
            row_amout = [self.promotionList count];
            break;
    }
    return row_amout;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSInteger section = indexPath.section;
    static NSString* cellId = @"section0";
    static NSString* cellId2 = @"otherSection";
    switch (section) {
        case 0:
         //   cell = [tableView dequeueReusableCellWithIdentifier:@"homeSection0Cell" forIndexPath:indexPath];
            cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"promote"];
            cell.textLabel.text = @"促销活动";
            
//            if  (cell == nil)
//            {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//               
//            }
            break;
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:cellId2 forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"Amazon"];
            NSString *promotionID = [self.promotionIds objectAtIndex:indexPath.row];
            cell.textLabel.text = [[self.promotionList objectForKey:promotionID] objectForKey:@"promotionName"];

//            if  (cell == nil)
//            {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
//                            }
    }
    return cell;
}

//- (NSString*)sectionIndexTitlesForTableView:(UITableView*) tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString* section_title;
//    switch (section) {
//        case 0:
//            section_title = @"";
//            break;
//        case 1:
//            section_title = @"类别";
//            break;
//        default:
//            section_title = @"热门资讯";
//            break;
//    }
//    return section_title;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 55;
        default:
           return 35;
    }

}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 30;//section头部高度
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection
                       :(NSInteger)section
{
    NSString* section_title;
    switch (section) {
        case 0:
            section_title = @"";
            break;
        default:
            section_title = @"热门资讯";
            break;
    }
    return section_title;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
//(NSIndexPath *)indexPath
//{
//    // 获取该应用的应用程序委托对象
//    FKAppDelegate* appDelegate = [UIApplication
//                                  sharedApplication].delegate;
//    // 获取Storyboard文件中ID为detail的视图控制器
//    FKDetailViewController* detailController = [self.storyboard
//                                                instantiateViewControllerWithIdentifier:@"detail"];
//    // 保存用户正在编辑的表格行对应的NSIndexPath
//    detailController.editingIndexPath = indexPath;
//    // 让应用程序的窗口显示detailViewController
//    appDelegate.window.rootViewController = detailController;
//}



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


#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

// Called when the search bar becomes first responder
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    
    NSString *pos = NSStringFromCGRect(self.searchController.searchBar.frame);
    NSLog(@"while editing,%@",pos);
    //    NSLog(@"while editing,navigationBar:%@",NSStringFromCGRect(self.navigationBar.frame));
    
    
    // Set searchString equal to what's typed into the searchbar
    NSString *searchString = self.searchController.searchBar.text;
    //    NSLog(@"%@",searchString);
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
#pragma mark - internal functions
- (void)GEtPromotrion
{
    self.promotionList = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"京东少儿经管原版专场200-100",@"promotionName",@"wwwGbJd1",@"link", nil],@"GbJd1",
    [NSMutableDictionary dictionaryWithObjectsAndKeys: @"京东二十余万图书每100-30",@"promotionName",@"wwwGbJd2",@"link", nil],@"GbJd2",
    [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"亚马逊22万中文书200-50",@"promotionName",@"wwwGbAm1",@"link", nil],@"GbAm1",
    [NSMutableDictionary dictionaryWithObjectsAndKeys: @"微信领券满200-80、150-50",@"promotionName",@"wwwGbWc1",@"link", nil],@"GbWc1",
    [NSMutableDictionary dictionaryWithObjectsAndKeys: @"当当万种图书200-100",@"promotionName",@"wwwGbDd1",@"link", nil],@"GbDd1",
    [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"当当教育类100-30 300-100",@"promotionName",@"wwwGbDd2",@"link", nil],@"GbDd2",
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:  @"亚马逊4万原版书满300减150",@"promotionName",@"wwwGbAm2",@"link", nil],@"GbAm2",
    [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"亚马逊电子书包月服务",@"promotionName",@"wwwPbAm1",@"link", nil],@"PbAm1",
    [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"淘宝云驭风全场满188减100",@"promotionName",@"wwwGbTb1",@"link", nil],@"GbTb1", nil];
    self.promotionIds = [self.promotionList allKeys];
    
    
//    self.promotionList = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//        [NSMutableDictionary alloc] initWithObjectsAndKeys: @"京东少儿经管原版专场200-100",@"promotionName",@"wwwGbJd1",@"link", nil],@"GbJd1",
//        [NSMutableDictionary alloc] initWithObjectsAndKeys: @"京东二十余万图书每100-30",@"promotionName",@"wwwGbJd2",@"link", nil],@"GbJd2",
//        [NSMutableDictionary alloc] initWithObjectsAndKeys: @"亚马逊22万中文书200-50",@"promotionName",@"wwwGbAm1",@"link", nil],@"GbAm1",
//        [NSMutableDictionary alloc] initWithObjectsAndKeys: @"微信领券满200-80、150-50",@"promotionName",@"wwwGbWc1",@"link", nil],@"GbWc1",
//        [NSMutableDictionary alloc] initWithObjectsAndKeys: @"当当万种图书200-100",@"promotionName",@"wwwGbDd1",@"link", nil],@"GbDd1",
//        [NSMutableDictionary alloc] initWithObjectsAndKeys: @"当当教育类100-30 300-100",@"promotionName",@"wwwGbDd2",@"link", nil],@"GbDd2",
//        [NSMutableDictionary alloc] initWithObjectsAndKeys:  @"亚马逊4万原版书满300减150",@"promotionName",@"wwwGbAm2",@"link", nil],@"GbAm2",
//        [NSMutableDictionary alloc] initWithObjectsAndKeys: @"亚马逊电子书包月服务",@"promotionName",@"wwwPbAm1",@"link", nil],@"PbAm1",
//        [NSMutableDictionary alloc] initWithObjectsAndKeys: @"淘宝云驭风全场满188减100",@"promotionName",@"wwwGbTb1",@"link", nil],@"GbTb1",
//    
//    ,nil];
    
}


@end
