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
@property (nonatomic,strong) NSMutableArray *tableData;
@end

@implementation tempHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableData = [NSMutableArray arrayWithObjects:@"疯狂Java讲义",
                      @"轻量级Java EE企业应用实战",
                      @"疯狂Android讲义",
                      @"疯狂Ajax讲义",
                      @"疯狂HTML5/CSS3/JavaScript讲义",
                      @"疯狂iOS讲义",
                      @"疯狂XML讲义",
                      @"经典Java EE企业应用实战"
                      @"Java入门与精通",
                      @"Java基础教程",
                      @"学习Java",
                      @"Objective-C基础" ,
                      @"Ruby入门与精通",
                      @"iOS开发教程" , nil];
    
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
            row_amout = [self.tableData count];
            break;
    }
    return row_amout;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"homeSection0Cell" forIndexPath:indexPath];
            break;
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:@"tempCell" forIndexPath:indexPath];
            cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
            break;
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
            return 90;
        default:
           return 45;
    }

}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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

- (void)filteredContentBySubString:(NSString *)subStr
{
    
    if ([subStr  isEqual: @""]) {
        
        // If empty the search results are the same as the original data
        self.searchResults = [self.tableData mutableCopy];
    } else {
        NSPredicate* pred = [NSPredicate predicateWithFormat:
                             @"SELF CONTAINS[c] %@" , subStr];
        // 使用谓词过滤NSArray
        self.searchResults = [NSMutableArray arrayWithArray:[self.tableData filteredArrayUsingPredicate:pred]];
        //        [self PrintArray:self.searchResults];
    }
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

@end
