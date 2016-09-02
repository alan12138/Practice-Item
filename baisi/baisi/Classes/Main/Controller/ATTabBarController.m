//
//  ATTabBarController.m
//  baisi
//
//  Created by 谷士雄 on 16/9/2.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATTabBarController.h"
#import "ATEssenceViewController.h"
#import "ATNewViewController.h"
#import "ATFriendTrends.h"
#import "ATMeViewController.h"
#import "ATNavigationController.h"

@implementation ATTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
   
    ATEssenceViewController *essenceVc = [[ATEssenceViewController alloc] init];
    [self setupChildViewController:essenceVc tabBarTitle:@"精华" navigationTitle:@"" tabBarImageName:@"tabBar_essence_icon" tabBarSelectedImageName:@"tabBar_essence_click_icon"];
    
    ATNewViewController *newVc = [[ATNewViewController alloc] init];
    [self setupChildViewController:newVc tabBarTitle:@"最新" navigationTitle:@"" tabBarImageName:@"tabBar_new_icon" tabBarSelectedImageName:@"tabBar_new_click_icon"];
    
    ATFriendTrends *friendTrendsVc = [[ATFriendTrends alloc] init];
    [self setupChildViewController:friendTrendsVc tabBarTitle:@"关注" navigationTitle:@"关注" tabBarImageName:@"tabBar_friendTrends_icon" tabBarSelectedImageName:@"tabBar_friendTrends_click_icon"];
    
    ATMeViewController *meVc = [[ATMeViewController alloc] init];
    [self setupChildViewController:meVc tabBarTitle:@"我" navigationTitle:@"我的" tabBarImageName:@"tabBar_me_icon" tabBarSelectedImageName:@"tabBar_me_click_icon"];
}

- (void)setupChildViewController:(UIViewController *)vc tabBarTitle:(NSString *)tabBarTitle navigationTitle:(NSString *)navigationTitle tabBarImageName:(NSString *)tabBarImageName tabBarSelectedImageName:(NSString *)tabBarSelectedImageName {
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = ATColor(115, 106, 103);
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSForegroundColorAttributeName] = ATColor(61, 61, 61);
    
    vc.tabBarItem.title = tabBarTitle;
    vc.navigationItem.title = navigationTitle;
    vc.tabBarItem.image = [UIImage imageNamed:tabBarImageName];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:tabBarSelectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc.tabBarItem setTitleTextAttributes:attr forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    ATNavigationController *nav = [[ATNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
}
@end
