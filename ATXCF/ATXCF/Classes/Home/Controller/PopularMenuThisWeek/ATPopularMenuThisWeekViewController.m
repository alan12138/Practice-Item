//
//  ATPopularMenuThisWeekViewController.m
//  ATXCF
//
//  Created by 谷士雄 on 16/9/30.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATPopularMenuThisWeekViewController.h"
#import "ATPopularMenuThisWeekTableViewCell.h"
#import "ATPopularMenuThisWeek.h"
#import "ATRefreshHeader.h"
#import "ATRefreshFooter.h"

static NSString * const AT_POPULARMENU_THISWEEK_TABLEVIEWCELL_ID = @"ATPopularMenuThisWeekTableViewCell";
static NSUInteger const COUNTS_PER_PAGE = 20;

@interface ATPopularMenuThisWeekViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *recipes;
@property (nonatomic, assign) NSUInteger currentPage;

@end

@implementation ATPopularMenuThisWeekViewController
- (NSMutableArray *)recipes {
    if (!_recipes) {
        _recipes = [NSMutableArray array];
    }
    return _recipes;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupMainView];
    // 添加刷新控件
    [self setupRefresh];
    //进入界面开始加载数据
    [self.mainTableView.mj_header beginRefreshing];
}
- (void)setupNav {
    self.navigationItem.title = @"本周流行菜谱";
}
- (void)setupMainView {
    UITableView *mainTableView = [[UITableView alloc] init];
    mainTableView.backgroundColor = ATMainBackgroundColor;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mainTableView registerClass:[ATPopularMenuThisWeekTableViewCell class] forCellReuseIdentifier:AT_POPULARMENU_THISWEEK_TABLEVIEWCELL_ID];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    self.mainTableView = mainTableView;
    
    [self.mainTableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
/**
 * 添加刷新控件
 */
- (void)setupRefresh
{
    self.mainTableView.mj_header = [ATRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewContents)];
    
    self.mainTableView.mj_footer = [ATRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreContents)];
}
#pragma mark - 加载用户数据
- (void)loadNewContents
{
    // 设置当前页码为1
    self.currentPage = 0;
    [self dataRequest];
}

- (void)loadMoreContents
{
//    self.currentPage++;
    [self dataRequest];
    [SVProgressHUD showErrorWithStatus:@"接口限制，翻页只能加载第一页数据"];
}
- (void)dataRequest {
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.xiachufang.com/v2/recipes/popular_v3.json?_ts=1475213331.427849&api_key=07397197043fafe11ce5c65c10febf84&api_sign=39b12f6e05fad639326a09b3dea8a315&limit=20&location_code=156320100000000&nonce=B5D31FD5-C008-4607-9472-57E7747F978B&offset=%ld&origin=iphone&sk=P3P_AXOxSdiRMuGbF3B-AQ&version=5.9.1",self.currentPage * COUNTS_PER_PAGE];
    [ATNetworking GET:urlStr parameters:nil progress:^(ATProgress *myProgress) {
        
    } success:^(ATURLSessionDataTask *myTask, id myResponseObject) {
        NSArray *recipes = myResponseObject[@"content"][@"recipes"];
        // 让底部控件结束刷新
        if (recipes.count == 0) { // 全部数据已经加载完毕
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        } else { // 还没有加载完毕
            [self.mainTableView.mj_footer endRefreshing];
        }
        // 结束刷新
        [self.mainTableView.mj_header endRefreshing];

        for (NSDictionary *recipe in recipes) {
            //字典转模型
            [self.recipes addObject:[ATPopularMenuThisWeek objectModelWithDict:recipe]];
        }
        //刷新列表
        [self.mainTableView reloadData];
        
    } failure:^(ATURLSessionDataTask *myTask, ATError *myError) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        // 结束刷新
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDatasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATPopularMenuThisWeekTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AT_POPULARMENU_THISWEEK_TABLEVIEWCELL_ID];
    
    ATPopularMenuThisWeek *popularMenuThisWeek = self.recipes[indexPath.row];

    cell.popularMenuThisWeek = popularMenuThisWeek;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATPopularMenuThisWeek *popularMenuThisWeek = self.recipes[indexPath.row];
    return [ATPopularMenuThisWeekTableViewCell cellHeightWithTableView:tableView transModel:^(UITableViewCell *sourceCell) {
        ATPopularMenuThisWeekTableViewCell *cell = (ATPopularMenuThisWeekTableViewCell *)sourceCell;
        // 配置数据
        cell.popularMenuThisWeek = popularMenuThisWeek;
        
    }];

}
@end
