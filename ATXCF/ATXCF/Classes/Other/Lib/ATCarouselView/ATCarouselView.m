//
//  ATCarouselView.m
//  轮播图
//
//  Created by lg on 16/7/4.
//  Copyright © 2016年 at. All rights reserved.
//

#import "ATCarouselView.h"
#import "UIButton+webCache.h"
#import "UIImageView+webCache.h"
#import "ATHomeHeaderPopEvent.h"

@interface ATCarouselView ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *titleLabels;
@property (nonatomic, strong) NSMutableArray *descLabels;
@property (nonatomic, strong) NSMutableArray *imageViews;
@end

@implementation ATCarouselView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //定义一个scrollView，最主要的轮播控件
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.delegate = self;
        //横竖两种滚轮都不显示
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        //需要分页
        scrollView.pagingEnabled = YES;
        //需要回弹
        scrollView.bounces = YES;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        //添加pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    //设置scrollView的frame
    self.scrollView.frame = self.bounds;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    //设置pageControl的位置
    CGFloat pageW = 100;
    CGFloat pageH = 20;
    CGFloat pageX = (width - pageW) / 2;
    CGFloat pageY = height - pageH;
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);

}
//根据传入的图片数组设置图片
- (void)setImages:(NSMutableArray *)images {
    _images = images;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    if (images.count == 1) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.hidden = NO;
    }
    //pageControl的页数就是图片的个数
    self.pageControl.numberOfPages = images.count;
    //默认一开始显示的是第0页
    self.pageControl.currentPage = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    //设置contentSize,不同轮播方向的时候contentSize是不一样的
    if (self.isScrollDorectionPortrait) { //竖向
        //contentSize放图片
        self.scrollView.contentSize = CGSizeMake(width, height * images.count);
    } else { //横向
        self.scrollView.contentSize = CGSizeMake(width * images.count, height);
    }

    NSMutableArray *titleLabels = [NSMutableArray array];
    self.titleLabels = titleLabels;
    NSMutableArray *descLabels = [NSMutableArray array];
    self.descLabels = descLabels;
    NSMutableArray *imageViews = [NSMutableArray array];
    self.imageViews = imageViews;
    //在scrollView中添加图片按钮，因为后面需要响应点击事件，所以我直接用按钮不用imageView了，感觉更方便一些
    for (int i = 0;i < images.count; i++) {
        UIButton *imageBtn = [[UIButton alloc] init];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [self.titleLabels addObject:titleLabel];
        
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.textColor = [UIColor lightGrayColor];
        descLabel.font = [UIFont systemFontOfSize:10];
        [self.descLabels addObject:descLabel];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.imageViews addObject:imageView];
        
        [imageBtn addSubview:titleLabel];
        [imageBtn addSubview:descLabel];
        [imageBtn addSubview:imageView];
        
        [self.scrollView addSubview:imageBtn];
        
        CGFloat titleLabelToTopMargin = 20;
        CGFloat descLabelToTitleLabelMargin = 5;
        CGFloat imageViewWidthHeight = 60;
        CGFloat imageViewTopMargin = 20;
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageBtn).offset(titleLabelToTopMargin);
            make.centerX.equalTo(imageBtn);
        }];
        [descLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.bottom).offset(descLabelToTitleLabelMargin);
            make.centerX.equalTo(titleLabel);
        }];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(imageViewWidthHeight);
            make.height.equalTo(imageViewWidthHeight);
            make.right.equalTo(imageBtn.right);
            make.top.equalTo(imageBtn.top).offset(imageViewTopMargin);
        }];
    }
        //设置图片的位置，并为按钮添加点击事件
    for (int i = 0; i < images.count; i++) {
        UIButton *imageBtn = self.scrollView.subviews[i];
        [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.isScrollDorectionPortrait) { //竖向
            imageBtn.frame = CGRectMake(0, i * height, width, height);
        } else { //横向
            imageBtn.frame = CGRectMake(i * width, 0, width, height);
        }
    }
    [self setContent];
    
}
- (void)setOtherInfos:(NSMutableArray *)otherInfos {
    _otherInfos = otherInfos;
    
    for (NSUInteger i = 0; i < otherInfos.count;i++) {
        ATHomeHeaderPopEvent *event = otherInfos[i];
        
        NSString *picUrlStr = event.dishes[@"dishes"][0][@"thumbnail_280"];
        UIImageView *imageView = self.imageViews[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:picUrlStr] placeholderImage:nil];
        
        NSString *title = [event.name substringToIndex:2];
        UILabel *titleLabel = self.titleLabels[i];
        titleLabel.text = [NSString stringWithFormat:@"— %@ —",title];
        
        NSString *desc = [NSString stringWithFormat:@"%ld作品", event.n_dishes];
        UILabel *descLabel = self.descLabels[i];
        descLabel.text = desc;
        
    }
}
//设置pageControl的CurrentPageColor
- (void)setCurrentPageColor:(UIColor *)currentPageColor {
    _currentPageColor = currentPageColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageColor;
}
//设置pageControl的pageColor
- (void)setPageColor:(UIColor *)pageColor {
    _pageColor = pageColor;
    self.pageControl.pageIndicatorTintColor = pageColor;
}
@synthesize scrollViewOffset = _scrollViewOffset;
@synthesize currentPage = _currentPage;
- (void)setScrollViewOffset:(CGPoint)scrollViewOffset {
    _scrollViewOffset = scrollViewOffset;
    self.scrollView.contentOffset = scrollViewOffset;
}
- (CGPoint)scrollViewOffset {
    return self.scrollView.contentOffset;
}
- (void)setCurrentPage:(NSUInteger)currentPage {
    _currentPage = currentPage;
    self.pageControl.currentPage = currentPage;
}
- (NSUInteger)currentPage {
    return self.pageControl.currentPage;
}
//设置显示内容
- (void)setContent {
    //设置三个imageBtn的显示图片
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        //取出imageBtn
        UIButton *imageBtn = self.scrollView.subviews[i];

        imageBtn.tag = i;
        //用上面处理好的索引给imageBtn设置图片
        if ([[self.images objectAtIndex:0] isKindOfClass:[NSString class]]) {
            [imageBtn sd_setImageWithURL:[NSURL URLWithString:self.images[i]] forState:UIControlStateNormal placeholderImage:nil];
        }
        [imageBtn setBackgroundImage:self.images[i] forState:UIControlStateNormal];
        [imageBtn setBackgroundImage:self.images[i] forState:UIControlStateHighlighted];
        
    }
}


#pragma mark - UIScrollViewDelegate
//拖拽的时候执行哪些操作
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.scrollBlock) {
        self.scrollBlock(scrollView);
    }
}

- (void)imageBtnClick:(UIButton *)btn {
    NSLog(@"%ld",btn.tag);
    if ([self.delegate respondsToSelector:@selector(carouselView:indexOfClickedImageBtn:)])
    {
        [self.delegate carouselView:self indexOfClickedImageBtn:btn.tag];
    }

}
@end
