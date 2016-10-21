//
//  ATTabBarController.m
//  ATXCF
//
//  Created by 谷士雄 on 16/9/23.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATTabBarController.h"
#import "ATNavigationController.h"
#import "ATHomeViewController.h"
#import "ATMarketViewController.h"
#import "ATMailboxViewController.h"
#import "ATMeViewController.h"

@implementation ATTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ATHomeViewController *homeVc = [[ATHomeViewController alloc] init];
    [self setupChildVc:homeVc tabBarImageName:@"tabADeselected" tabBarSelectedImageName:@"tabASelected" tabBarName:@"下厨房" navigationTitle:@""];
    
    //这里为了好看点暂时先这样写了，是为了去掉导航栏，注意只是为了好看一点而已，而不是应该这么做
    ATMarketViewController *marketVc = [[ATMarketViewController alloc] init];
//    [self setupChildVc:marketVc tabBarImageName:@"tabBDeselected" tabBarSelectedImageName:@"tabBSelected" tabBarName:@"市集" navigationTitle:@""];
    //取消图片渲染
    marketVc.tabBarItem.image = [[UIImage imageNamed:@"tabBDeselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    marketVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //取消字体渲染
    NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
    textDict[NSForegroundColorAttributeName] = ATColor(74, 74, 69, 1.0);
    NSMutableDictionary *textSelectedDict = [NSMutableDictionary dictionary];
    textSelectedDict[NSForegroundColorAttributeName] = ATColor(246, 77, 64, 1.0);
    [marketVc.tabBarItem setTitleTextAttributes:textDict forState:UIControlStateNormal];
    [marketVc.tabBarItem setTitleTextAttributes:textSelectedDict forState:UIControlStateSelected];
    
    marketVc.tabBarItem.title = @"市集";
    
    marketVc.navigationItem.title = @"";
    
    [self addChildViewController:marketVc];

    
    ATMailboxViewController *mailboxVc = [[ATMailboxViewController alloc] init];
    [self setupChildVc:mailboxVc tabBarImageName:@"tabCDeselected" tabBarSelectedImageName:@"tabCSelected" tabBarName:@"信箱" navigationTitle:@"信箱"];
    
    ATMeViewController *meVc = [[ATMeViewController alloc] init];
    [self setupChildVc:meVc tabBarImageName:@"tabDDeselected" tabBarSelectedImageName:@"tabDSelected" tabBarName:@"我" navigationTitle:@"我"];
    
}
/**
 *  添加自控制器
 */
- (void)setupChildVc:(UIViewController *)vc tabBarImageName:(NSString *)tabBarImageName tabBarSelectedImageName:(NSString *)tabBarSelectedImageName tabBarName:(NSString *)tabBarName navigationTitle:(NSString *)navigationTitle {
    //取消图片渲染
    vc.tabBarItem.image = [[UIImage imageNamed:tabBarImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:tabBarSelectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //取消字体渲染
    NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
    textDict[NSForegroundColorAttributeName] = ATColor(74, 74, 69, 1.0);
    NSMutableDictionary *textSelectedDict = [NSMutableDictionary dictionary];
    textSelectedDict[NSForegroundColorAttributeName] = ATColor(246, 77, 64, 1.0);
    [vc.tabBarItem setTitleTextAttributes:textDict forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:textSelectedDict forState:UIControlStateSelected];
    
    vc.tabBarItem.title = tabBarName;
    
    vc.navigationItem.title = navigationTitle;
    
    ATNavigationController *nav = [[ATNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}
@end
