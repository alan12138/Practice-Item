//
//  ViewController.m
//  ATLiveApp
//
//  Created by 张伟 on 2020/1/2.
//  Copyright © 2020 张伟. All rights reserved.
//

#import "ViewController.h"
#import "ATShowViewController.h"
#import "ATShowListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *showBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 100)];
    [showBtn setTitle:@"直播" forState:UIControlStateNormal];
    [showBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(showBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
    
    UIButton *listBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, [UIScreen mainScreen].bounds.size.width, 100)];
    [listBtn setTitle:@"直播列表" forState:UIControlStateNormal];
    [listBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [listBtn addTarget:self action:@selector(listBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listBtn];
}

- (void)showBtnClick {
    ATShowViewController *vc = [[ATShowViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)listBtnClick {
    ATShowListViewController *vc = [[ATShowListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
