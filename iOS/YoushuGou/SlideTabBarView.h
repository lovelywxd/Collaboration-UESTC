//
//  SlideTabBarView.h
//  slideTabBar
//
//  Created by 苏丽荣 on 16/6/22.
//  Copyright © 2016年 苏丽荣. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SlideTabBarViewDelegate <NSObject>
- (UITableView*) tableForPage:(NSInteger)page withFrame:(CGRect)frame;
- (CGFloat) heightForTopBar;
- (NSArray*) titlesForTapButton;
@end

@protocol SlideTabBarViewDataSource<NSObject>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView atPage:(NSInteger)page;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section atPage:(NSInteger)page;
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath atPage:(NSInteger)page;
-(UITableViewCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath atPage:(NSInteger)page;
@end

@interface SlideTabBarView : UIScrollView
//@interface SlideTabBarView : UISc
@property (assign) NSInteger tabCount;
@property (nonatomic,assign) NSInteger topBarHeight;
@property (nonatomic,assign) NSInteger indicatorSlideHeight;
@property (nonatomic, strong) id<SlideTabBarViewDelegate,SlideTabBarViewDataSource> slideTabBarViewDelegate;
-(instancetype)initWithFrame:(CGRect)frame withDelegate:(id)delegate;
- (void)setColor:(UIColor*)color AtIndex:(NSInteger)index;


@end
