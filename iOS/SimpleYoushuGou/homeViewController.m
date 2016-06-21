//
//  homeViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/17.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "homeViewController.h"
#import "searchResultTableViewController.h"

@interface homeViewController ()<UISearchResultsUpdating>
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic,strong) NSMutableArray *tableData;
@end

@implementation homeViewController

- (void) PrintArray:(NSArray*)array
{
    for (id obj in array){
        NSLog(@"%@",obj);
    }
}

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
    
    self.navigationItem.titleView = self.searchController.searchBar;

    NSString *pos = NSStringFromCGRect(self.searchController.searchBar.frame);
    NSLog(@"%@",pos);
////    [self.view addSubview:self.searchController.searchBar];
//     NSLog(@"navigationBar:%@",NSStringFromCGRect(self.navigationBar.frame));
//    self.title = @"主页";
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






//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    NSLog(@"cancel search");
//}
//
//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//     NSLog(@"text did change");
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//     NSLog(@"searchBarSearchButtonClicked");
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

//#pragma mark - UITableViewDataSource & UITableViewDelegate
//-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (tableView == self.searchDisplayController) {
//        
//    }
//    if (tableView == mySearchDisplayController.searchResultsTableView)
//    {
//        return [self numberOfRowsWithSearchResultTableView];
//    }
//    return 0;
//}
//
//
//
//-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == mySearchDisplayController.searchResultsTableView)
//    {
//        return [self searchTableView:mySearchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath];
//    }
//    else
//    {
//        static NSString *cellID = @"search_cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        if (cell == nil)
//        {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        }
//        return cell;
//    }
//}
//
//
//
//#pragma mark - UISearchDisplayController   <UITableViewDataSource> dataSource
//-(NSInteger)numberOfRowsWithSearchResultTableView
//{
//    return suggestResults.count + 1;
//}
//-(UITableViewCell*)searchTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *suggestId = @"suggestCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:suggestId];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:suggestId];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    if (indexPath.row == suggestResults.count)
//    {
//        cell.textLabel.text = [NSLocalizedString(@"Search: ", @"查找: ") stringByAppendingString:mySearchBar.text];
//    }
//    else
//    {
//        cell.textLabel.text = [suggestResults objectAtIndex:indexPath.row];
//    }
//    return cell;
//}

//#pragma mark - UISearchDisplayController <UITableViewDelegate> delegate
//-(void) searchTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *keyword = nil;
//    if (indexPath.row == suggestResults.count)
//    {
//        keyword = mySearchBar.text;
//    }
//    else
//    {
//        keyword = [suggestResults objectAtIndex:indexPath.row];
//    }
//    [mySearchBar resignFirstResponder];
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
