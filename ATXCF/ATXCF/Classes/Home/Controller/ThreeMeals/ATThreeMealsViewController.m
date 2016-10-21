//
//  ATThreeMealsViewController.m
//  ATXCF
//
//  Created by 谷士雄 on 16/10/17.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATThreeMealsViewController.h"
#import "ATThreeMealsCollectionViewCell.h"
#import "ATThreeMealsHeaderCollectionReusableView.h"
#import "ATThreeMealsHeader.h"
#import "ATThreeMealsDish.h"
#import "ATRefreshFooter.h"

static NSString * const AT_CELL_ID = @"collectionCell";
static NSString * const AT_HEADER_ID = @"collectionHeader";
static CGFloat const AT_CELL_MARGIN = 4;

@interface ATThreeMealsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) ATThreeMealsHeader *header;
@property (nonatomic, strong) NSMutableArray *dishes;
@end

@implementation ATThreeMealsViewController
- (NSMutableArray *)dishes {
    if (!_dishes) {
        _dishes = [NSMutableArray array];
    }
    return _dishes;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showErrorWithStatus:@"接口都加密了，所以只抓了个早餐展示一下界面，其他感觉没必要搞了，很简单"];
    self.view.backgroundColor = ATMainBackgroundColor;
    [self setupMainCollectionView];
    ATSetupNavShare
    [self headerDataRequest];
    [self dataRequest];
    [self setupRefresh];
}
/**
 * 添加刷新控件
 */
- (void)setupRefresh
{
    self.mainCollectionView.mj_footer = [ATRefreshFooter footerWithRefreshingBlock:^{
        //    self.currentPage++;
        [self dataRequest];
        [SVProgressHUD showErrorWithStatus:@"接口限制，翻页只能加载第一页数据"];
    }];
}

/**
 *  初始化mainCollectionView
 */
- (void)setupMainCollectionView {
    // 1. 实例化一个 collectionViewFlowLayout
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    // 修改滚动方向
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 2. 实例化一个 collectionView
    UICollectionView *mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    
    // 3. 注册一个cell
    [mainCollectionView registerClass:[ATThreeMealsCollectionViewCell class] forCellWithReuseIdentifier:AT_CELL_ID];
    [mainCollectionView registerClass:[ATThreeMealsHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:AT_HEADER_ID];
    
    // 4. 设置数据源代理
    mainCollectionView.dataSource = self;
    mainCollectionView.delegate = self;
    
    // 5. 添加到控制器的view上
    [self.view addSubview:mainCollectionView];
    
    // 6. 设置collectionView的背景色
    mainCollectionView.backgroundColor = ATMainBackgroundColor;
    
    self.mainCollectionView = mainCollectionView;
    
    [self.mainCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)headerDataRequest {
    NSString *urlStr = @"http://api.xiachufang.com/v2/events/show.json?_ts=1476928585.793782&api_key=07397197043fafe11ce5c65c10febf84&api_sign=0af2301241e232730fe725bdd8a56faa&id=100172843&nonce=4F94F110-0A4E-4C45-9741-CD0FD6B292CB&origin=iphone&sk=P3P_AXOxSdiRMuGbF3B-AQ&version=5.9.3";
    
    [ATNetworking GET:urlStr parameters:nil progress:^(ATProgress *myProgress) {
        
    } success:^(ATURLSessionDataTask *myTask, id myResponseObject) {
        self.header = [ATThreeMealsHeader objectModelWithDict:myResponseObject[@"content"][@"event"]];
        [self.mainCollectionView reloadData];
    } failure:^(ATURLSessionDataTask *myTask, ATError *myError) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}
- (void)dataRequest {
    NSString *urlStr = @"http://api.xiachufang.com/v2/events/100172843/dishes_order_by_time_v3.json?_ts=1476928586.045658&api_key=07397197043fafe11ce5c65c10febf84&api_sign=90819c01cfbe938988e4fd0adb513c1d&detail=true&dish_sizes=360w_360h%2C600&limit=18&nonce=3196D1EA-2DB4-43A1-B1FA-31B3EA332A69&offset=0&origin=iphone&sk=P3P_AXOxSdiRMuGbF3B-AQ&timestamp=1476928586&version=5.9.3";
    
    [ATNetworking GET:urlStr parameters:nil progress:^(ATProgress *myProgress) {
        
    } success:^(ATURLSessionDataTask *myTask, id myResponseObject) {
        for (NSDictionary *dish in myResponseObject[@"content"][@"dishes"]) {
            ATThreeMealsDish *threeMealsDish = [ATThreeMealsDish objectModelWithDict:dish];
            [self.dishes addObject:threeMealsDish];
        }
        
        [self.mainCollectionView.mj_header endRefreshing];
        // 让底部控件结束刷新
        if ([myResponseObject[@"content"][@"dishes"] count] == 0) { // 全部数据已经加载完毕
            [self.mainCollectionView.mj_footer endRefreshingWithNoMoreData];
        } else { // 还没有加载完毕
            [self.mainCollectionView.mj_footer endRefreshing];
        }

        [self.mainCollectionView reloadData];
    } failure:^(ATURLSessionDataTask *myTask, ATError *myError) {
        // 结束刷新
        [self.mainCollectionView.mj_header endRefreshing];
        [self.mainCollectionView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}
#pragma mar - collectionViewDataSource and delegate
// 组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
// 行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dishes.count;
}
// 每一行显示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 直接到缓存池中去找cell
    ATThreeMealsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AT_CELL_ID forIndexPath:indexPath];
    cell.dish = self.dishes[indexPath.row];
    return cell;
}
/**
 *  修改item的大小，可每行自定义
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //高度包含商品图和商品描述，这里设置图以外部分的比例是图的三分之二
    return CGSizeMake(screenWidth / 2 - AT_CELL_MARGIN / 2, screenWidth * 5 / 6);
}
/**
 *  设定全局的区内边距，可以设定指定区的内边距
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}
/**
 *  minimumLineSpacing属性
 
 * 设定全局的行间距，如果想要设定指定区内Cell的最小行距，可以使用下面方法：
 */

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return AT_CELL_MARGIN;
}

/**
 *  minimumInteritemSpacing属性
 * 设定全局的Cell间距，如果想要设定指定区内Cell的最小间距，可以使用下面方法：
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
/**
 *  点击cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ATLog(@"collectionCell 被点击 -- %ld --- %ld", indexPath.section, indexPath.row);
}
/**
 *  为collection view添加一个补充视图(页眉或页脚)
 */
#pragma mark -  设置组头/尾 的时候要通过代理方法进行返回
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ATThreeMealsHeaderCollectionReusableView *headView = nil;
    
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:AT_HEADER_ID forIndexPath:indexPath];
    }
    headView.threeMealsHeader = self.header;
    return headView;
}
/**
 * 设定页眉和页脚的全局尺寸，需要注意的是，根据滚动方向不同，header和footer的width和height中只有一个会起作用。如果要单独设置指定区内的页面和页脚尺寸，可以使用下面方法：
 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat height = [ATThreeMealsHeaderCollectionReusableView headerHeightWithHeader:self.header];
    return CGSizeMake(screenWidth, height);
}
#pragma mark - 分享功能
ATShare
@end
