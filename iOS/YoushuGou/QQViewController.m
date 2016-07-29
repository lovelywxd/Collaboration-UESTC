//
//  QQViewController.m
//  QQLogin
//
//  Created by Reese on 13-6-17.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "QQViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

#define ANIMATION_DURATION 0.3f

@interface QQViewController ()

@end

@implementation QQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *account1=[NSDictionary dictionaryWithObjectsAndKeys:@"Syr",@"userNumber",@"1234567",@"passWord",@"girl",@"userHead", nil];
    NSDictionary *account2=[NSDictionary dictionaryWithObjectsAndKeys:@"Sjn",@"userNumber",@"1234567",@"passWord",@"boy",@"userHead", nil];
    NSDictionary *account3=[NSDictionary dictionaryWithObjectsAndKeys:@"Slr",@"userNumber",@"1234567",@"passWord",@"heart",@"userHead", nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"girl",@"Syr", @"boy",@"Sjn",@"heart",@"Slr",nil];
    NSArray *account = [NSArray arrayWithObjects:account1,account2,account3, nil];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"accountList"];
    _currentAccounts=[[NSMutableArray arrayWithObjects:account1,account2, nil]retain];
    
    
    [self reloadAccountBox];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_dropButton release];
    [_moveDownGroup release];
    [_account_box release];
    [_userNumber release];
    [_userPassword release];
    [_userLargeHead release];
    [_numberLabel release];
    [_passwordLabel release];
    [super dealloc];
}
- (IBAction)dropDown:(id)sender {
    if ([sender isSelected]) {
        
        [self hideAccountBox];
        
    }else
    {
        
        [self showAccountBox];
        
    }
    
}

-(void)showAccountBox
{
    [_dropButton setSelected:YES];
    CABasicAnimation *move=[CABasicAnimation animationWithKeyPath:@"position"];
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(_moveDownGroup.center.x, _moveDownGroup.center.y)]];
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(_moveDownGroup.center.x, _moveDownGroup.center.y+_account_box.frame.size.height)]];
    [move setDuration:ANIMATION_DURATION];
    [_moveDownGroup.layer addAnimation:move forKey:nil];
    
    
    [_account_box setHidden:NO];
    
    //模糊处理
    [_userLargeHead setAlpha:0.5f];
    [_numberLabel setAlpha:0.5f];
    [_passwordLabel setAlpha:0.5f];
    [_userNumber setAlpha:0.5f];
    [_userPassword setAlpha:0.5f];
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.2, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    CABasicAnimation *center=[CABasicAnimation animationWithKeyPath:@"position"];
    [center setFromValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.center.x, _account_box.center.y-_account_box.bounds.size.height/2)]];
    [center setToValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.center.x, _account_box.center.y)]];
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,center, nil]];
    [group setDuration:ANIMATION_DURATION];
    [_account_box.layer addAnimation:group forKey:nil];
    
    
    
    [_moveDownGroup setCenter:CGPointMake(_moveDownGroup.center.x, _moveDownGroup.center.y+_account_box.frame.size.height)];
    
}
-(void)hideAccountBox
{
    [_dropButton setSelected:NO];
    CABasicAnimation *move=[CABasicAnimation animationWithKeyPath:@"position"];
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(_moveDownGroup.center.x, _moveDownGroup.center.y)]];
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(_moveDownGroup.center.x, _moveDownGroup.center.y-_account_box.frame.size.height)]];
    [move setDuration:ANIMATION_DURATION];
    [_moveDownGroup.layer addAnimation:move forKey:nil];
    
    [_moveDownGroup setCenter:CGPointMake(_moveDownGroup.center.x, _moveDownGroup.center.y-_account_box.frame.size.height)];
    [_userLargeHead setAlpha:1.0f];
    [_numberLabel setAlpha:1.0f];
    [_passwordLabel setAlpha:1.0f];
    [_userNumber setAlpha:1.0f];
    [_userPassword setAlpha:1.0f];
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.2, 1.0)]];
    
    CABasicAnimation *center=[CABasicAnimation animationWithKeyPath:@"position"];
    [center setFromValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.center.x, _account_box.center.y)]];
    [center setToValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.center.x, _account_box.center.y-_account_box.bounds.size.height/2)]];
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,center, nil]];
    [group setDuration:ANIMATION_DURATION];
    [_account_box.layer addAnimation:group forKey:nil];
    
    
    [_account_box performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:NO] afterDelay:ANIMATION_DURATION];
}


-(void)reloadAccountBox
{
    for (UIView* view in _account_box.subviews) {
        if (view.tag!=20000) {
            [view removeFromSuperview];
        } 
    }
    int count=_currentAccounts.count;
    //图片之间的间距
    CGFloat insets;
    
    
    //图片的宽度与背景的宽度
    CGFloat imageWidth=49,bgWidth=288,bgHeight=80;
    
    //根据账号数量对3的商来计算整个view高度的调整
    CGFloat newHeight;
    newHeight=((count-1)/3)*80+80;
    if (newHeight!=bgHeight) {
        [_account_box setFrame:CGRectMake(_account_box.frame.origin.x, _account_box.frame.origin.y, _account_box.frame.size.width, newHeight)];
    }
    
    CGFloat paddingTop=(bgHeight-imageWidth)/2;
    CGFloat paddingLeft=(320-bgWidth)/2;
    if (count >3) {
        insets=insets=(bgWidth-imageWidth*3)/4;
    }else{
    //根据图片数量对3取模计算间距
    switch (count%3) {
        case 0:
            insets=(bgWidth-imageWidth*3)/4;
            
            break;
        case 1:
            insets=(bgWidth-imageWidth)/2;
            break;
        case 2:
            insets=(bgWidth-imageWidth*2)/3;
            break;
        default:
            break;
    }
    }
    


    for (int i=0;i<_currentAccounts.count;i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(paddingLeft+insets+(i%3)*(imageWidth+insets), paddingTop+80*(i/3), imageWidth, imageWidth)];
        [button setBackgroundImage:[UIImage imageNamed:@"login_dropdown_avatar_border"] forState:UIControlStateNormal];
        [button.imageView setImage:[UIImage imageNamed:@"login_avatar"]];
        button.tag=10000+i;
        [button addTarget:self action:@selector(chooseAccount:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45 , 45)];
        [headImage.layer setCornerRadius:3.0];
        [headImage setClipsToBounds:YES];
        [headImage setCenter:CGPointMake(button.center.x, button.center.y)];
        [headImage setImage:[UIImage imageNamed:[_currentAccounts[i] objectForKey:@"userHead"]]];
        [_account_box addSubview:headImage];
        [_account_box addSubview:button];
        
    }
}

- (void)chooseAccount:(UIButton*)button
{
    int accountIndex=button.tag-10000;
    [_userNumber setText:[[_currentAccounts objectAtIndex:accountIndex] objectForKey:@"userNumber"] ];
    [_userPassword setText:[[_currentAccounts objectAtIndex:accountIndex] objectForKey:@"passWord"]];
    [_userLargeHead setImage:[UIImage imageNamed:[[_currentAccounts objectAtIndex:accountIndex] objectForKey:@"userHead"]]];
    [self hideAccountBox];
}

- (IBAction)login:(id)sender {
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@/user/login/",appdele.baseUrl];
    NSString *username = _userNumber.text;
    NSString *passwd = _userPassword.text;
//        NSDictionary *account=[NSDictionary dictionaryWithObjectsAndKeys:_userNumber.text,@"userNumber",_userPassword.text,@"passWord",@"3.jpeg",@"userHead", nil];
    
        NSDictionary *logindata = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"name",passwd,@"passwd",nil];
    [appdele.manager
     POST:url
     parameters:logindata  // 指定请求参数
     // 获取服务器响应成功时激发的代码块
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *fields= [operation.response allHeaderFields];
         NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:url]];
         [[NSUserDefaults standardUserDefaults] setObject:[[NSHTTPCookie requestHeaderFieldsWithCookies:cookies] objectForKey:@"Cookie"] forKey:@"userCookie"];
         
         NSString *logingUser = _userNumber.text;
         
         NSString *loginStatus = [responseObject objectForKey:@"status"];
         if ([loginStatus isEqualToString:@"0"]) {
             
             //设别上存储的所有用户
             NSArray *oldUserList = [[NSUserDefaults standardUserDefaults] objectForKey:@"userList"];
             NSMutableArray *newUserList;
             if (oldUserList) {
                 newUserList = [NSMutableArray arrayWithArray:oldUserList];
                 if (![oldUserList containsObject:logingUser]) {
                     //若此前未存储过该用户信息，存储用户名以及密码
                     [newUserList addObject:logingUser];
                 }
             }
             else {
                 //             设备上没有用户
                 newUserList = [NSMutableArray arrayWithObject:logingUser];
             }
             [[NSUserDefaults standardUserDefaults] setObject:[newUserList copy] forKey:@"userList"];
             [[NSUserDefaults standardUserDefaults] setObject:logingUser forKey:@"currentOnLineUser"];
             [[NSUserDefaults standardUserDefaults] setObject:logingUser forKey:@"currentUser"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             
             
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 UIViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
                 appdele.window.rootViewController = homeVC;
         }
         else {
             NSString *result = [NSString stringWithFormat:@"login fail.info:%@",[responseObject objectForKey:@"data"]];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login result" message:result preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
     }
     // 获取服务器响应失败时激发的代码块
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"服务器无响应" message:@"登录失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
     }];

    [self reloadAccountBox];
    
}

- (IBAction)goRegister:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userNumber resignFirstResponder];
    [_userPassword resignFirstResponder];
}
@end
