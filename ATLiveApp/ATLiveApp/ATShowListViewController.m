//
//  ATShowListViewController.m
//  ATLiveApp
//
//  Created by 张伟 on 2020/1/3.
//  Copyright © 2020 张伟. All rights reserved.
//

#import "ATShowListViewController.h"
#import "ATPlayViewController.h"
#import "ATNetworking.h"
#import "NSObject+ATProperty.h"
#import "NSObject+ATObjectModel.h"
#import "ATShowItem.h"
#import "ATShowItemTableViewCell.h"

@interface ATShowListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation ATShowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [NSMutableArray array];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [ATNetworking GET:@"http://live.9158.com/Room/GetNewRoomOnline?page=1" parameters:nil progress:^(ATProgress *myProgress) {
        
    } success:^(ATURLSessionDataTask *myTask, id myResponseObject) {
        NSLog(@"%@",myResponseObject);
        [NSObject createPropertyCodeWithDict:myResponseObject[@"data"][@"list"][0]];
        for (NSDictionary *dict in myResponseObject[@"data"][@"list"]) {
            ATShowItem *item = [ATShowItem objectModelWithDict:dict];
            [self.items addObject:item];
        }
        [self.tableView reloadData];
    } failure:^(ATURLSessionDataTask *myTask, ATError *myError) {
        
    }];
    
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATShowItemTableViewCell *cell = [ATShowItemTableViewCell cellWithTableView:tableView];
    cell.item = self.items[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 310;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ATPlayViewController *vc = [[ATPlayViewController alloc] init];
    vc.item = self.items[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
