//
//  tempHomeTableViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/21.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "tempHomeTableViewController.h"
#import "searchResultTableViewController.h"
#import "ActivitysViewController.h"
@interface tempHomeTableViewController ()<UISearchResultsUpdating>
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic,strong) NSMutableDictionary *promotionList;
@property (nonatomic,strong) NSArray *promotionIds;
@end

@implementation tempHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.searchController.view setBackgroundColor:[UIColor blueColor]];
    if (self.navigationController == nil) {
        NSLog(@"self.navigationController == nil");
    }
    else if(self.navigationController.navigationItem == nil)
    {
        NSLog(@"self.navigationController.navigationItem == nil");
    }

    self.tableView.tableHeaderView = self.searchController.searchBar;
    
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
            cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"promote"];
            cell.textLabel.text = @"图书促销";
            break;
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:cellId2 forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"Amazon"];
            NSString *promotionID = [self.promotionIds objectAtIndex:indexPath.row];
            cell.textLabel.text = [[self.promotionList objectForKey:promotionID] objectForKey:@"promotionName"];
    }
    return cell;
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath
{
    //                 // 获取指定的Storyboard，name填写Storyboard的文件名
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 从Storyboard上按照identifier获取指定的界面（VC），identifier必须是唯一的
    ActivitysViewController* ActivitysVC = [storyboard instantiateViewControllerWithIdentifier:@"ActivitysVC"];
//
//    [self.navigationController pushViewController:ActivitysVC animated:YES];
    
    
    switch (indexPath.section) {
        case 0:
            [self.navigationController pushViewController:ActivitysVC animated:YES];
            break;
        default:
            NSLog(@"selected:section:%ld,row:%ld",indexPath.section,indexPath.row);
    }
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
    
}


@end
