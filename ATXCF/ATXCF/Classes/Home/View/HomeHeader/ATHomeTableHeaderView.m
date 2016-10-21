//
//  ATHomeTableHeaderView.m
//  ATXCF
//
//  Created by 谷士雄 on 16/9/28.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATHomeTableHeaderView.h"
#import "ATHomeHeaderSection.h"
#import "UIButton+webCache.h"
#import "UIImageView+webCache.h"
#import "ATCarouselView.h"
#import "ATHomeHeaderPopEvent.h"

static CGFloat const LEFT_RIGHT_MARGIN = 20;
static NSUInteger const SECTION_COUNT = 4;
#define coverImage [UIImage imageNamed:@"themeSmallPic"]

@interface ATHomeTableHeaderView ()<ATCarouselViewDelegate>
@property (nonatomic, strong) NSMutableArray *sectionBtns;
@property (nonatomic, weak) ATImageView *leftImageView;
@property (nonatomic, weak) ATImageView *rightImageView;
@property (nonatomic, weak) ATCarouselView *carouselView;
@property (nonatomic, weak) ATCarouselView *carouselViewCover;
@property (nonatomic, weak) ATImageView *coverImageView;
@end

@implementation ATHomeTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupSubViews];
        [self autoLayoutSubviews];
        
    }
    return self;
}
- (NSMutableArray *)sectionBtns {
    if (!_sectionBtns) {
        _sectionBtns = [NSMutableArray array];
    }
    return _sectionBtns;
}
- (void)setSections:(NSMutableArray *)sections {
    _sections = sections;
    for (NSUInteger i = 0; i < sections.count; i++) {
        if (sections.count > 4 && sections.count == 0) {
            return;
        }
        ATButton *sectionBtn = self.sectionBtns[i];
        ATHomeHeaderSection *section = sections[i];
        [sectionBtn setImageURL:[NSURL URLWithString:section.picurl]];
        [sectionBtn setTitle:section.name];
        sectionBtn.tap = ^ {
            if (self.sectionClick) {
                self.sectionClick(sections[i]);
            }
        };

    }
}
- (void)setEvents:(NSMutableArray *)events {
    _events = events;
    
    NSMutableArray *pageImages = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"themeSmallPicForBreakfast"], [UIImage imageNamed:@"themeSmallPicForLaunch"],
                                  [UIImage imageNamed:@"themeSmallPicForSupper"],nil];
    NSMutableArray *subPageImages = [NSMutableArray array];
    for (NSUInteger i = 0; i < events.count; i++) {
        [subPageImages addObject:pageImages[i]];
    }
    
    self.carouselView.images = subPageImages;
    
    NSMutableArray *images = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.carouselView.images.count; i++) {
        images[i] = [UIImage new];
    }
    self.carouselViewCover.images = images;
    
    __block ATCarouselView *tempCarouselView = self.carouselView;
    self.carouselViewCover.scrollBlock = ^(UIScrollView *scrollView) {
        
        CGPoint offset = scrollView.contentOffset;
        CGFloat offsetX = offset.x;
        CGFloat width = scrollView.frame.size.width;
        int pageNum = (offsetX + .5f *  width) / width;
        
        tempCarouselView.currentPage = pageNum;
        
        CGPoint scrollViewOffset = tempCarouselView.scrollViewOffset;
        
        scrollViewOffset.x = offsetX;
        
        tempCarouselView.scrollViewOffset = scrollViewOffset;
    };

    self.carouselView.otherInfos = events;

}
- (void)setHeaderleftPicUrlStr:(NSString *)headerleftPicUrlStr {
    _headerleftPicUrlStr = headerleftPicUrlStr;
    [self.leftImageView setMainImageURL:[NSURL URLWithString:headerleftPicUrlStr]];
}
- (void)setupSubViews {
    for (NSUInteger i = 0; i < SECTION_COUNT; i++) {
        ATButton *sectionBtn = [[ATButton alloc] init];
        
        sectionBtn.buttonStyle = ATButtonStyleUpImageDownTitle;
        sectionBtn.imageViewWidth = 45;
        sectionBtn.imageViewHeight = 45;
        sectionBtn.titleFontSize = 12;
        
        [self.sectionBtns addObject:sectionBtn];
        [self addSubview:sectionBtn];
    }
    
    ATImageView *leftImageView = [[ATImageView alloc] init];
    leftImageView.imageViewStyle = ATImageViewStylePicAndString;
    leftImageView.image = [UIImage imageNamed:@"feedsNoFriends"];
    leftImageView.downLabelStr = @"本周流行菜谱";
    leftImageView.downLabelFontSize = 14;
    leftImageView.downLabelBold = YES;
    leftImageView.downLabelColor = [UIColor whiteColor];
    leftImageView.tap = ^{
        if (self.picClick) {
            self.picClick();
        }
    };
    [self addSubview:leftImageView];
    self.leftImageView = leftImageView;
    
    ATImageView *rightImageView = [[ATImageView alloc] init];
    rightImageView.imageViewStyle = ATImageViewStylePicAndString;
    rightImageView.image = [UIImage imageNamed:@"feedsNoFriends"];
    rightImageView.subImage = [UIImage imageNamed:@"feedsNoFriendsIcon"];
    rightImageView.downLabelStr = @"查看好友并关注";
    rightImageView.downLabelFontSize = 14;
    rightImageView.downLabelBold = YES;
    rightImageView.downLabelColor = [UIColor whiteColor];
    [self addSubview:rightImageView];
    self.rightImageView = rightImageView;

    ATCarouselView *carouselView = [[ATCarouselView alloc] init];
    [self addSubview:carouselView];
    self.carouselView = carouselView;
    carouselView.delegate = self;
    carouselView.currentPageColor = ATColor(246, 77, 64, 1.0);
    carouselView.pageColor = [UIColor lightGrayColor];

    ATImageView *coverImageView = [[ATImageView alloc] init];
    coverImageView.userInteractionEnabled = YES;
    coverImageView.image = coverImage;
    [self addSubview:coverImageView];
    self.coverImageView = coverImageView;
    
    ATCarouselView *carouselViewCover = [[ATCarouselView alloc] init];
    [self addSubview:carouselViewCover];
    self.carouselViewCover = carouselViewCover;
    carouselViewCover.delegate = self;
    carouselViewCover.currentPageColor = [UIColor clearColor];
    carouselViewCover.pageColor = [UIColor clearColor];
}

- (void)autoLayoutSubviews {
    for (NSUInteger i = 0; i < SECTION_COUNT; i++) {
        CGFloat y = 20;
        CGFloat width = 60;
        CGFloat height = 80;
        CGFloat margin = (screenWidth - SECTION_COUNT * width - 2 * LEFT_RIGHT_MARGIN) / (SECTION_COUNT - 1);
        [self.sectionBtns[i] setFrame:CGRectMake(LEFT_RIGHT_MARGIN + (margin + width) * i, y, width, height)];
    }
    
    ATButton *sectionButton = self.sectionBtns[0];
    CGFloat picHeight = 120;
    [self.leftImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFT_RIGHT_MARGIN);
        make.top.equalTo(sectionButton.bottom);
        make.height.equalTo(picHeight);
    }];

    CGFloat centerMargin = 10;
    [self.rightImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-LEFT_RIGHT_MARGIN);
        make.top.equalTo(self.leftImageView);
        make.height.equalTo(self.leftImageView);
        make.width.equalTo(self.leftImageView);
        make.left.equalTo(self.leftImageView.right).offset(centerMargin);
    }];
    
    CGFloat topMargin = 5;
    CGFloat carouselHeight = 90;
    [self.carouselView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImageView.bottom).offset(topMargin);
        make.left.equalTo(self.leftImageView);
        make.right.equalTo(self.rightImageView);
        make.height.equalTo(carouselHeight);
    }];
    
    [self.coverImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.carouselView);
        make.bottom.equalTo(self.carouselView);
        make.width.equalTo(coverImage.size.width);
    }];
    
    [self.carouselViewCover makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImageView.bottom).offset(topMargin);
        make.left.equalTo(self.leftImageView);
        make.right.equalTo(self.rightImageView);
        make.height.equalTo(carouselHeight);
    }];

}
- (void)carouselView:(ATCarouselView *)carouselView indexOfClickedImageBtn:(NSUInteger)index {
//    NSLog(@"点击了第%ld张图片",index);
    if (self.carouselClick) {
        self.carouselClick(index);
    }
}
@end
