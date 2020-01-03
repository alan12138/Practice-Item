//
//  ATPlayViewController.m
//  ATLiveApp
//
//  Created by 张伟 on 2020/1/3.
//  Copyright © 2020 张伟. All rights reserved.
//

#import "ATPlayViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "ATShowItem.h"

@interface ATPlayViewController ()
@property (nonatomic, strong) IJKFFMoviePlayerController *ijkLiveVeiw;
@end

@implementation ATPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // 拉流地址
    NSURL *url = [NSURL URLWithString:self.item.flv];

    _ijkLiveVeiw = [[IJKFFMoviePlayerController alloc]initWithContentURL:url withOptions:nil];
    _ijkLiveVeiw.view.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    [_ijkLiveVeiw prepareToPlay];

    [self.view addSubview:_ijkLiveVeiw.view];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    if (_ijkLiveVeiw) {
        [_ijkLiveVeiw pause];
        [_ijkLiveVeiw stop];
        [_ijkLiveVeiw shutdown];
    }
}


@end
