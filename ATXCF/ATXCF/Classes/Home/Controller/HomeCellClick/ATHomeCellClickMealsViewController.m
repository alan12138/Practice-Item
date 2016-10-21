//
//  ATHomeCellClickMealsViewController.m
//  ATXCF
//
//  Created by 谷士雄 on 16/10/21.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATHomeCellClickMealsViewController.h"
#import "ATHomeCellClickMealsTableViewCell.h"
#import "ATRefreshFooter.h"
#import "ATHomeCellClickMeals.h"
#import "ATHomeCellClickMealsHeader.h"
#import "ATHomeCellClickMealsTableHeaderView.h"

static NSString * const AT_HOMECELL_CLICK_MEALS_TABLEVIEWCELL_ID = @"ATHomeCellClickMealsTableViewCell";
static CGFloat const AT_HEADERVIEW_HEIGHT = 120;

@interface ATHomeCellClickMealsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *recipes;
@property (nonatomic, strong) ATHomeCellClickMealsHeader *header;
@end

@implementation ATHomeCellClickMealsViewController
- (NSMutableArray *)recipes {
    if (!_recipes) {
        _recipes = [NSMutableArray array];
    }
    return _recipes;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    ATSetupNavShare
    [self setupMainView];
    // 添加刷新控件
    [self setupRefresh];
    
    [self dataRequest];
    [self headerDataRequest];
}
- (void)setupMainView {
    UITableView *mainTableView = [[UITableView alloc] init];
    mainTableView.backgroundColor = [UIColor whiteColor];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mainTableView registerClass:[ATHomeCellClickMealsTableViewCell class] forCellReuseIdentifier:AT_HOMECELL_CLICK_MEALS_TABLEVIEWCELL_ID];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    self.mainTableView = mainTableView;
    
    [self.mainTableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
- (void)setupHeaderView {
    
    ATHomeCellClickMealsTableHeaderView *headerView = [[ATHomeCellClickMealsTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, AT_HEADERVIEW_HEIGHT)];
    headerView.header = self.header;
    self.mainTableView.tableHeaderView = headerView;
}
/**
 * 添加刷新控件
 */
- (void)setupRefresh
{
    self.mainTableView.mj_footer = [ATRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreContents)];
}
- (void)loadMoreContents
{
    //    self.currentPage++;
    [self dataRequest];
    [SVProgressHUD showErrorWithStatus:@"接口限制，翻页只能加载第一页数据"];
}

- (void)headerDataRequest {
    NSString *urlStr = @"http://api.xiachufang.com/v2/recipe_lists/show.json?_ts=1477033047.179221&api_key=07397197043fafe11ce5c65c10febf84&api_sign=a387519a658c704c9d964b12b2d4e67c&id=102390860&location_code=156320100000000&nonce=E0D9E4DE-0B5A-48A6-AEB5-9AB71805E26C&origin=iphone&pic_size=720&sk=P3P_AXOxSdiRMuGbF3B-AQ&version=5.9.3";
    [ATNetworking GET:urlStr parameters:nil progress:^(ATProgress *myProgress) {
        
    } success:^(ATURLSessionDataTask *myTask, id myResponseObject) {
        self.header = [ATHomeCellClickMealsHeader objectModelWithDict:myResponseObject[@"content"]];

        [self setupHeaderView];
        
    } failure:^(ATURLSessionDataTask *myTask, ATError *myError) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        // 结束刷新
        [self.mainTableView.mj_footer endRefreshing];
    }];

}

- (void)dataRequest {
    NSString *urlStr = @"http://api.xiachufang.com/v2/recipe_lists/103854752/recipes_v3.json?_ts=1477021470.212568&api_key=07397197043fafe11ce5c65c10febf84&api_sign=e4c731694d630dede39075f86d977eb2&limit=20&location_code=156320100000000&nonce=7A8BEB75-EF88-4756-B2B4-F6EECB80B808&offset=0&origin=iphone&sk=P3P_AXOxSdiRMuGbF3B-AQ&version=5.9.3";
    [ATNetworking GET:urlStr parameters:nil progress:^(ATProgress *myProgress) {
        
    } success:^(ATURLSessionDataTask *myTask, id myResponseObject) {
        NSArray *recipes = myResponseObject[@"content"][@"recipes"];
        // 让底部控件结束刷新
        if (recipes.count == 0) { // 全部数据已经加载完毕
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        } else { // 还没有加载完毕
            [self.mainTableView.mj_footer endRefreshing];
        }
        
        for (NSDictionary *recipe in recipes) {
            //字典转模型
            [self.recipes addObject:[ATHomeCellClickMeals objectModelWithDict:recipe]];
        }
        //刷新列表
        [self.mainTableView reloadData];
        
    } failure:^(ATURLSessionDataTask *myTask, ATError *myError) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        // 结束刷新
        [self.mainTableView.mj_footer endRefreshing];
    }];
}
#pragma mark - UITableViewDatasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATHomeCellClickMealsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AT_HOMECELL_CLICK_MEALS_TABLEVIEWCELL_ID];
    
    ATHomeCellClickMeals *homeCellClickMeals = self.recipes[indexPath.row];
    
    cell.homeCellClickMeals = homeCellClickMeals;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATHomeCellClickMeals *homeCellClickMeals = self.recipes[indexPath.row];
    return [ATHomeCellClickMealsTableViewCell cellHeightWithTableView:tableView transModel:^(UITableViewCell *sourceCell) {
        ATHomeCellClickMealsTableViewCell *cell = (ATHomeCellClickMealsTableViewCell *)sourceCell;
        // 配置数据
        cell.homeCellClickMeals = homeCellClickMeals;
    }];
}

#pragma mark - 分享功能
ATShare

@end
