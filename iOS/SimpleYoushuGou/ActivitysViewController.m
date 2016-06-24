//
//  ActivitysViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/23.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "ActivitysViewController.h"
#import "SlideTabBarView.h"

@interface ActivitysViewController ()
@property (nonatomic,strong) SlideTabBarView* slideBarView;
@end

@implementation ActivitysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//
    NSInteger lowerBarHeight =  self.tabBarController.tabBar.frame.size.height;
    NSInteger higherBarHeight =  self.navigationController.navigationBar.frame.size.height;
    NSInteger statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    [self.view setBackgroundColor:[UIColor grayColor]];

    CGRect rootviewFrame = self.view.frame;
    NSLog(@"rootviewFrame:%@",NSStringFromCGRect(rootviewFrame));
    NSLog(@"statusBarHeight:%ld,lowerBarHeight:%ld,higherBarHeight:%ld",statusBarHeight,lowerBarHeight,higherBarHeight);
//    self.navigationController.navigationBar.hidden = YES;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    NSLog(@"main screen:%@",NSStringFromCGRect(frame));
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:frame];
//    UIView *view = [[UIView alloc] initWithFrame:frame];
//    [view setBackgroundColor:[UIColor redColor]];
    
    NSInteger slideBarViewHeight = frame.size.height - (lowerBarHeight + statusBarHeight + higherBarHeight);
    CGRect slideBarViewFrame = CGRectMake(0,0,frame.size.width,slideBarViewHeight);
    
    self.slideBarView = [[SlideTabBarView alloc] initWithFrame:slideBarViewFrame withDelegate:self];
     NSLog(@"slideBarViewFrame:%@",NSStringFromCGRect(slideBarViewFrame));
    
    [self.slideBarView setColor:[UIColor purpleColor] AtIndex:2];

    [self.view addSubview:view];
    [view addSubview:self.self.slideBarView];
//    [self.navigationController
}

- (CGFloat) heightForTopBar
{
    return 30;
}
- (NSArray*) titlesForTapButton
{
    return [NSArray arrayWithObjects:@"全部", @"京东", @"当当", nil];
}

- (UITableView*) tableForPage:(NSInteger)page withFrame:(CGRect)frame {
    
    NSLog(@"tableForPage:%@",NSStringFromCGRect(frame));
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
    return tableView;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView atPage:(NSInteger)page{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section atPage:(NSInteger)page{
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath atPage:(NSInteger)page
{
    return 30;
}

-(UITableViewCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath atPage:(NSInteger)page
{
    static NSString* cellId = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",page];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"row:%ld",indexPath.row];
        
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
