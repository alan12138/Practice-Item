//
//  ATHomeViewController.m
//  ATXCF
//
//  Created by 谷士雄 on 16/9/23.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATHomeViewController.h"
#import "ATSearchBar.h"
#import "ATHomeTableHeaderView.h"
#import "ATHomeHeaderSection.h"
#import "ATWebViewController.h"
#import "UIBarButtonItem+Item.h"
#import "ATPopularMenuThisWeekViewController.h"
#import "ATHomeHeaderPopEvent.h"
#import "ATHomeTableViewHeaderView.h"
#import "ATHomeTableViewCell.h"
#import "ATRefreshHeader.h"
#import "ATRefreshFooter.h"
#import "ATHomeCellItem.h"
#import "ATHomeCellIssue.h"
#import "ATThreeMealsViewController.h"
#import "ATHomeCellClickMealsViewController.h"

static NSString * const AT_SECTION_HEADERVIEW_ID = @"sectionHeaderView";
static NSString * const AT_HOME_CELL_ID = @"homeCell";
static CGFloat const HEADER_HEIGHT = 44;

@interface ATHomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *headerSections;
@property (nonatomic, copy) NSString *headerleftPicUrlStr;
@property (nonatomic, strong) NSMutableArray *popEvents;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *issues;
@end

@implementation ATHomeViewController
- (NSMutableArray *)headerSections {
    if (!_headerSections) {
        _headerSections = [NSMutableArray array];
    }
    return _headerSections;
}
- (NSMutableArray *)popEvents {
    if (!_popEvents) {
        _popEvents = [NSMutableArray array];
    }
    return _popEvents;
}
- (NSMutableArray *)issues {
    if (!_issues) {
        _issues = [NSMutableArray array];
    }
    return _issues;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupNav];
    [self setupMainView];
    [self setupRefresh];
    [self headerDataRequest];
    [self mainDataRequest];
}

- (void)setupNav {

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"homepageCreateRecipeButton"] highImage:[UIImage imageNamed:@"homepageCreateRecipeButton"] target:self action:@selector(leftBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"buylistButtonImage"] highImage:[UIImage imageNamed:@"buylistButtonImage"] target:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    ATSearchBar *searchBar = [ATSearchBar searchBarWithPlaceholder:@"菜谱、食材"];
    self.navigationItem.titleView = searchBar;
    
    for (UIView *view in searchBar.subviews) { //去掉搜索框背景避免pop的时候闪烁
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }

}
- (void)setupMainView {
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusHeight - navigationBarHeight - tabBarHeight) style:UITableViewStylePlain];
    [mainTableView registerClass:[ATHomeTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:AT_SECTION_HEADERVIEW_ID];
    [mainTableView registerClass:[ATHomeTableViewCell class] forCellReuseIdentifier:AT_HOME_CELL_ID];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mainTableView setBackgroundColor:ATMainBackgroundColor];
    //设置拖拽的时候键盘自动退出
    mainTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    self.mainTableView = mainTableView;
}
- (void)setUpMainHeaderView {
    ATHomeTableHeaderView *tableHeaderView = [[ATHomeTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 320)];
    
    //将模型数据传递给cell
    tableHeaderView.sections = self.headerSections;
    tableHeaderView.events = self.popEvents;
    tableHeaderView.sectionClick = ^(ATHomeHeaderSection *section) {
        ATWebViewController *webVc = [[ATWebViewController alloc] init];
        webVc.urlStr = section.url;
        webVc.navTitle = section.name;
        [self.navigationController pushViewController:webVc animated:YES];
    };
    tableHeaderView.headerleftPicUrlStr = self.headerleftPicUrlStr;
    tableHeaderView.picClick = ^ {
        ATPopularMenuThisWeekViewController *vc = [[ATPopularMenuThisWeekViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    self.mainTableView.tableHeaderView = tableHeaderView;
    
    tableHeaderView.carouselClick = ^(NSUInteger index) {
        ATThreeMealsViewController *threeMealsVc = [[ATThreeMealsViewController alloc] init];
        [self.navigationController pushViewController:threeMealsVc animated:YES];
    };

}
/**
 * 添加刷新控件
 */
- (void)setupRefresh
{
    self.mainTableView.mj_header = [ATRefreshHeader headerWithRefreshingBlock:^{
        // 设置当前页码为1
        self.currentPage = 0;
        [self mainDataRequest];
    }];
    
    self.mainTableView.mj_footer = [ATRefreshFooter footerWithRefreshingBlock:^{
        //    self.currentPage++;
        [self mainDataRequest];
        [SVProgressHUD showErrorWithStatus:@"接口限制，翻页只能加载第一页数据"];
    }];
}

- (void)headerDataRequest {
    //官方api经常改变，所以这里获取过段时间可能和官方不一样，运行显示的头部图片也就可能和官方不一样
    NSString *urlStr = @"http://api.xiachufang.com/v2/init_page_v5.json?_ts=1476069626.283277&api_key=07397197043fafe11ce5c65c10febf84&api_sign=ddd5686242405ebbb65cb424d92f114b&location_code=156320100000000&nonce=41C7518F-DFF0-498C-8DD9-A233623E2ACC&origin=iphone&sk=P3P_AXOxSdiRMuGbF3B-AQ&timezone=Asia/Shanghai&version=5.9.3";

    [ATNetworking GET:urlStr parameters:nil progress:^(ATProgress *myProgress) {
        
    } success:^(ATURLSessionDataTask *myTask, id myResponseObject) {
//        ATLog(@"%@",myResponseObject);
        //获取4块section的信息
        NSArray *navs = myResponseObject[@"content"][@"navs"];
        for (NSDictionary *section in navs) {
            //字典转模型
            [self.headerSections addObject:[ATHomeHeaderSection objectModelWithDict:section]];
        }
        NSString *headerleftPicUrlStr = myResponseObject[@"content"][@"pop_recipe_picurl"];
        self.headerleftPicUrlStr = headerleftPicUrlStr;
        //获取轮播信息
        NSArray *popEvents = myResponseObject[@"content"][@"pop_events"][@"events"];

        for (NSDictionary *event in popEvents) {
            //字典转模型
            [self.popEvents addObject:[ATHomeHeaderPopEvent objectModelWithDict:event]];
        }
        
        [self setUpMainHeaderView];

    } failure:^(ATURLSessionDataTask *myTask, ATError *myError) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}
- (void)mainDataRequest {
    NSString *urlStr = @"http://api.xiachufang.com/v2/issues/list.json?_ts=1476078240.162809&api_key=07397197043fafe11ce5c65c10febf84&api_sign=b626d948f12d611f7e6d42573ce8f339&cursor=&location_code=156320100000000&nonce=DAC022AC-B7EC-4611-AE57-C136CCF95075&origin=iphone&size=2&sk=P3P_AXOxSdiRMuGbF3B-AQ&timezone=Asia/Shanghai&version=5.9.3";
    [ATNetworking GET:urlStr parameters:nil progress:^(ATProgress *myProgress) {
        
    } success:^(ATURLSessionDataTask *myTask, id myResponseObject) {
    
        NSArray *issues = myResponseObject[@"content"][@"issues"];
        for (NSUInteger i = 0; i < issues.count; i++) {
            ATHomeCellIssue *cellIssue = [ATHomeCellIssue objectModelWithDict:issues[i]];
            [self.issues addObject:cellIssue];
        }
        
        // 结束刷新
        [self.mainTableView.mj_header endRefreshing];
        // 让底部控件结束刷新
        if (issues.count == 0) { // 全部数据已经加载完毕
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        } else { // 还没有加载完毕
            [self.mainTableView.mj_footer endRefreshing];
        }
        
        [self.mainTableView reloadData];
        
    } failure:^(ATURLSessionDataTask *myTask, ATError *myError) {
        // 结束刷新
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];

}
//取消粘滞效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = HEADER_HEIGHT;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
#pragma mark - UITableViewDatasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.issues.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.issues[section] items] count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ATHomeTableViewHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:AT_SECTION_HEADERVIEW_ID];
    sectionHeaderView.contentView.backgroundColor = [UIColor whiteColor];
    sectionHeaderView.title = [self.issues[section] title];;
    return sectionHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADER_HEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AT_HOME_CELL_ID];
    //删除cell的所有子视图
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    NSArray *items = [self.issues[indexPath.section] items];
    ATHomeCellItem *cellItem = [ATHomeCellItem objectModelWithDict:items[indexPath.row]];
    cell.cellItem = cellItem;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *items = [self.issues[indexPath.section] items];
    ATHomeCellItem *cellItem = nil;
    if (items.count) {
        cellItem = [ATHomeCellItem objectModelWithDict:items[indexPath.row]];
    }
    return [ATHomeTableViewCell cellHeightWithTableView:tableView transModel:^(UITableViewCell *sourceCell) {
        ATHomeTableViewCell *cell = (ATHomeTableViewCell *)sourceCell;
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        // 配置数据
        cell.cellItem = cellItem;
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *items = [self.issues[indexPath.section] items];
    ATHomeCellItem *cellItem = [ATHomeCellItem objectModelWithDict:items[indexPath.row]];
#warning 接口原因，我只能用这种笨拙的方式判断跳转到哪种控制器了，而且每种cell我只能跳转到同一个接口数据的控制器
    if (cellItem.contents.image.url.length && cellItem.contents.title_1st.length && cellItem.contents.title_2nd.length) {
        ATHomeCellClickMealsViewController *mealVc = [[ATHomeCellClickMealsViewController alloc] init];
        [self.navigationController pushViewController:mealVc animated:YES];
    } else {
        //一般都是根据id判断跳转控制器，但是下厨房首页cell点击跳转没什么规律，跳转的都是原生页面不是网页，而且接口加密，所以其他类型的cell跳转不太好做，所以只尝试做了上面一个，下面的暂时不做了，感觉继续跟它纠结下去有点浪费时间了
        ATLog(@"888");
    }
}
#pragma mark - 点击事件
- (void)leftBarButtonClick:(UIBarButtonItem *)barButtonItem {
    ATLog(@"leftBarButtonClick");
}
- (void)rightBarButtonClick:(UIBarButtonItem *)barButtonItem {
    ATLog(@"rightBarButtonClick");
}

@end
