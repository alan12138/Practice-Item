//
//  ATNavigationController.m
//  ATXCF
//
//  Created by 谷士雄 on 16/9/23.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATNavigationController.h"
#import "UIImage+Image.h"

@implementation ATNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //取消导航栏细线，且导航栏为白色
    [self.navigationBar setBackgroundImage:[UIImage imageWithStretchableName:@"navigationBack"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    
    //开启ios右滑返回
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
    }

}
/**
 *  重写这个方法,能拦截所有的push操作
 *
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count != 0) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"backStretchBackgroundNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
        [viewController.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
}
- (void)back {
    [self popViewControllerAnimated:YES];
}
@end
