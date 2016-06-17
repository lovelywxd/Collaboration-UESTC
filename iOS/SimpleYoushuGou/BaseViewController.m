//
//  baseViewController.m
//  MyBookRecycle
//
//  Created by 苏丽荣 on 16/6/17.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import "baseViewController.h"
#import "homeViewController.h"
#import "collectionViewController.h"
#import "groupBuyViewController.h"
#import "assistantViewController.h"
#import "userSettingViewController.h"

@interface baseViewController ()

@end

@implementation baseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    ［UIViewController pref
    //设置Navigation Bar背景图片
    UIImage *title_bg = [UIImage imageNamed:@"head_background.png"];  //获取图片
    CGSize titleSize = self.navigationController.navigationBar.bounds.size;  //获取Navigation Bar的位置和大小
    titleSize.height += 60;
    title_bg = [self scaleToSize:title_bg size:titleSize];//设置图片的大小与Navigation Bar相同
    [self.navigationController.navigationBar
     setBackgroundImage:title_bg
     forBarMetrics:UIBarMetricsDefault];  //设置背景
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.navigationController.navigationBar.tintColor = [UIColor redColor];//实际上这个改变的是navigationbar中字的颜色
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(goHomeVC)];
    UIBarButtonItem *two = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(goCollectionVC)];
    UIBarButtonItem *three = [[UIBarButtonItem alloc] initWithTitle:@"拼单" style:UIBarButtonItemStylePlain target:self action:@selector(goGroupBuyVC)];
    UIBarButtonItem *four = [[UIBarButtonItem alloc] initWithTitle:@"校园助手" style:UIBarButtonItemStylePlain target:self action:@selector(goAssistantVC)];
    NSArray* items = [NSArray arrayWithObjects:flexItem, one, flexItem, two, flexItem, three,flexItem,four,flexItem,nil];
    [self setToolbarItems:items];

    UIBarButtonItem* left = [[UIBarButtonItem alloc] initWithTitle:@"用户设置" style:UIBarButtonItemStylePlain target:self action:@selector(goUserSettingVC)];
    [self.navigationItem setLeftBarButtonItem:left];
}

//调整图片大小
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)goUserSettingVC
{
    // 从Storyboard上按照identifier获取指定的界面（VC），identifier必须是唯一的
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeViewController* homeVC = [storyboard instantiateViewControllerWithIdentifier:@"userSettingVC"];
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (void)goHomeVC
{
    // 从Storyboard上按照identifier获取指定的界面（VC），identifier必须是唯一的
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeViewController* homeVC = [storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (void)goCollectionVC
{
    // 从Storyboard上按照identifier获取指定的界面（VC），identifier必须是唯一的
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeViewController* collectionVC = [storyboard instantiateViewControllerWithIdentifier:@"collectionVC"];
    [self.navigationController pushViewController:collectionVC animated:NO];
}


- (void)goGroupBuyVC
{
    // 从Storyboard上按照identifier获取指定的界面（VC），identifier必须是唯一的
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    groupBuyViewController* groupBuyVC = [storyboard instantiateViewControllerWithIdentifier:@"groupBuyVC"];
    [self.navigationController pushViewController:groupBuyVC animated:NO];
}

- (void)goAssistantVC
{
    // 从Storyboard上按照identifier获取指定的界面（VC），identifier必须是唯一的
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    groupBuyViewController* groupBuyVC = [storyboard instantiateViewControllerWithIdentifier:@"assistantVC"];
    [self.navigationController pushViewController:groupBuyVC animated:NO];
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
