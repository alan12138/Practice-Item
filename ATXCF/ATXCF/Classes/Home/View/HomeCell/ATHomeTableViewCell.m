//
//  ATHomeTableViewCell.m
//  ATXCF
//
//  Created by 谷士雄 on 16/10/10.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATHomeTableViewCell.h"
#import "ATImageView.h"
#import "ATHomeCellItem.h"

static CGFloat const MAIN_IMAGEVIEW_MARGIN = 20;
static CGFloat const SEPERATORVIEW_HEIGHT = 1;
static CGFloat const SEPERATORVIEW_TOP_MARGIN = 20;
static CGFloat const DESCLABEL_TO_TITLELABEL_MARGIN = 10;
static CGFloat const TITLELABEL_TO_MAINIMAGEVIEW_MARGIN = 20;
static CGFloat const USERICONIMAGEVIEW_WIDTH_HEIGHT = 50;
static CGFloat const USERICONIMAGEVIEW_TOP_TO_MAINIMAGEVIEW = 10;
static CGFloat const USERNAMELABEL_TOP_TO_USERICONIMAGEVIEW = 5;
static CGFloat const SCORELABEL_TOP_TO_DESCLABEL = 10;

/**
 *  1.图片加图片文字
 *  2.图片加图片下文字标题、文字描述
 *  3.图片加图片下文字标题、文字描述、作者、评分、多少人做过（评分可能没有）
 *  4.只有标题和回答
 *  5.图片加图片文字（文字可只有一行的）
 *  6.图片
 */
@interface ATHomeTableViewCell ()
@property (nonatomic, weak) ATImageView *mainImageView;
@property (nonatomic, weak) UIView *mainImageCoverView;
@property (nonatomic, weak) ATImageView *userIconImageView;
@property (nonatomic, weak) ATLabel *userNameLabel;
@property (nonatomic, weak) ATLabel *titleLabel;
@property (nonatomic, weak) ATLabel *descLabel;
@property (nonatomic, strong) ATLabel *scoreLabel;
@property (nonatomic, weak) ATLabel *personNumLabel;
@property (nonatomic, weak) ATLabel *answerPersonsLabel;
@property (nonatomic, weak) UIView *separatorView;
@end

@implementation ATHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//添加并设置大图
- (void)setMainImageViewWithCellItem:(ATHomeCellItem *)cellItem {
    ATImageView *mainImageView = [[ATImageView alloc] init];
    mainImageView.userInteractionEnabled = NO;
    mainImageView.imageViewStyle = ATImageViewStyleStringAndString;
    mainImageView.upLabelStr = @"";
    mainImageView.downLabelStr = @"";
    mainImageView.upLabelColor = [UIColor whiteColor];
    mainImageView.downLabelColor = [UIColor whiteColor];
    mainImageView.upLabelFontSize = 20;
    mainImageView.downLabelFontSize = 14;
    mainImageView.upLabelBold = YES;
    mainImageView.downLabelBold = YES;
    
    [self.contentView addSubview:mainImageView];
    self.mainImageView = mainImageView;
    
    UIView *mainImageCoverView = [[UIView alloc] init];
    mainImageCoverView.backgroundColor = ATColor(100, 100, 100, 0.2);
    [self.mainImageView insertSubview:mainImageCoverView atIndex:1];
    self.mainImageCoverView = mainImageCoverView;

    //设置大图内容和尺寸
    [self.mainImageView setMainImageURL:[NSURL URLWithString:cellItem.contents.image.url]];
    self.mainImageView.upLabelStr = cellItem.contents.title_1st;
    self.mainImageView.downLabelStr = cellItem.contents.title_2nd;
    if (cellItem.contents.whisper.length) {
        self.mainImageView.downLabelStr = cellItem.contents.whisper;
    }
    
    CGFloat whProportion = 1.3; //默认一个比例
    if (cellItem.contents.image.width != nil) {
        if ([cellItem.contents.image.width floatValue] != 0 && [cellItem.contents.image.height floatValue] != 0) {
            whProportion = [cellItem.contents.image.width floatValue] / [cellItem.contents.image.height floatValue];
        }
        
    }
    CGFloat mainImageViewWidth = screenWidth - 2 * MAIN_IMAGEVIEW_MARGIN;
    CGFloat mainImageViewHeight = mainImageViewWidth / whProportion;
    
    [self.mainImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(MAIN_IMAGEVIEW_MARGIN);
        make.right.equalTo(self.contentView).offset(-MAIN_IMAGEVIEW_MARGIN);
        make.top.equalTo(self.contentView).offset(MAIN_IMAGEVIEW_MARGIN);
        make.height.equalTo(mainImageViewHeight);
    }];
    [self.mainImageCoverView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainImageView);
    }];

}
//添加并设置头像
- (void)setAuthorWithCellItem:(ATHomeCellItem *)cellItem {
    ATImageView *userIconImageView = [[ATImageView alloc] init];
    [self.contentView addSubview:userIconImageView];
    self.userIconImageView = userIconImageView;
    //剪切原型图片
    userIconImageView.layer.masksToBounds = YES;
    userIconImageView.layer.cornerRadius = USERICONIMAGEVIEW_WIDTH_HEIGHT / 2;
    
    ATLabel *userNameLabel = [[ATLabel alloc] init];
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.textColor = [UIColor lightGrayColor];
    userNameLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:userNameLabel];
    self.userNameLabel = userNameLabel;

    //设置头像内容和尺寸
    [self.userIconImageView setMainImageURL:[NSURL URLWithString:cellItem.contents.author.photo]];
    [self.userNameLabel setText:cellItem.contents.author.name];
    
    [self.userIconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mainImageView);
        make.top.equalTo(self.mainImageView.bottom).offset(USERICONIMAGEVIEW_TOP_TO_MAINIMAGEVIEW);
        make.width.equalTo(USERICONIMAGEVIEW_WIDTH_HEIGHT);
        make.height.equalTo(USERICONIMAGEVIEW_WIDTH_HEIGHT);
    }];
    
    [self.userNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIconImageView);
        make.top.equalTo(self.userIconImageView.bottom).offset(USERNAMELABEL_TOP_TO_USERICONIMAGEVIEW);
        make.right.equalTo(self.userIconImageView);
    }];

}
//根据传入模型设置cell
- (void)setCellItem:(ATHomeCellItem *)cellItem {
    _cellItem = cellItem;
    
    //3
    if (cellItem.contents.image.url.length && cellItem.contents.title.length && cellItem.contents.desc.length && cellItem.contents.author.photo.length && cellItem.contents.n_cooked) {
//        ATLog(@"3");
        
        //添加子控件
        //添加并设置大图
        [self setMainImageViewWithCellItem:cellItem];
        //添加并设置头像
        [self setAuthorWithCellItem:cellItem];
        
        ATLabel *titleLabel = [[ATLabel alloc] init];
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        ATLabel *descLabel = [[ATLabel alloc] init];
        descLabel.numberOfLines = 0;
        descLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:descLabel];
        self.descLabel = descLabel;
        
        ATLabel *scoreLabel = [[ATLabel alloc] init];
        scoreLabel.textColor = [UIColor lightGrayColor];
        scoreLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:scoreLabel];
        self.scoreLabel = scoreLabel;
        
        ATLabel *personNumLabel = [[ATLabel alloc] init];
        personNumLabel.textColor = [UIColor lightGrayColor];
        personNumLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:personNumLabel];
        self.personNumLabel = personNumLabel;
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = ATSeparatorBackgroundColor;
        [self.contentView addSubview:separatorView];
        self.separatorView = separatorView;

        // 应该始终要加上这一句,不然在6/6plus上就不准确了
        self.titleLabel.preferredMaxLayoutWidth = screenWidth - MAIN_IMAGEVIEW_MARGIN * 2 - self.userIconImageView.frame.size.width;
        self.descLabel.preferredMaxLayoutWidth = screenWidth - MAIN_IMAGEVIEW_MARGIN * 2 - self.userIconImageView.frame.size.width;
        
        //设置标题文字和描述文字的内容和尺寸
        self.titleLabel.text = cellItem.contents.title;
        self.descLabel.text = cellItem.contents.desc;
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainImageView);
            make.right.equalTo(self.userIconImageView.left);
            make.top.equalTo(self.mainImageView.bottom).offset(TITLELABEL_TO_MAINIMAGEVIEW_MARGIN);
        }];
        [self.descLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.bottom).offset(DESCLABEL_TO_TITLELABEL_MARGIN);
        }];
        //设置评分和多少人做过的内容和尺寸
        self.scoreLabel.text = [NSString stringWithFormat:@"%.1lf分 • ",[cellItem.contents.score floatValue]];
        self.personNumLabel.text = [NSString stringWithFormat:@"%ld人做过",cellItem.contents.n_cooked];
        [self.scoreLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.descLabel);
            make.top.equalTo(self.descLabel.bottom).offset(SCORELABEL_TOP_TO_DESCLABEL);
        }];
        if (cellItem.contents.score.length) {
            [self.personNumLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scoreLabel.right);
                make.top.equalTo(self.descLabel.bottom).offset(SCORELABEL_TOP_TO_DESCLABEL);
            }];
        } else {
            [self.scoreLabel removeFromSuperview];
            [self.personNumLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.descLabel);
                make.top.equalTo(self.descLabel.bottom).offset(SCORELABEL_TOP_TO_DESCLABEL);
            }];
        }
        [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.personNumLabel.bottom).offset(SEPERATORVIEW_TOP_MARGIN);
            make.height.equalTo(SEPERATORVIEW_HEIGHT);
        }];
    }
    //2
    else if (cellItem.contents.image.url.length && cellItem.contents.title.length && cellItem.contents.desc.length) {
//        ATLog(@"2   ------------    %@",cellItem.contents.title_1st);

        //添加子控件
        //添加并设置大图
        [self setMainImageViewWithCellItem:cellItem];
        
        ATLabel *titleLabel = [[ATLabel alloc] init];
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        ATLabel *descLabel = [[ATLabel alloc] init];
        descLabel.numberOfLines = 0;
        descLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:descLabel];
        self.descLabel = descLabel;

        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = ATSeparatorBackgroundColor;
        [self.contentView addSubview:separatorView];
        self.separatorView = separatorView;
        
        // 应该始终要加上这一句,不然在6/6plus上就不准确了
        self.titleLabel.preferredMaxLayoutWidth = screenWidth - MAIN_IMAGEVIEW_MARGIN * 2;
        self.descLabel.preferredMaxLayoutWidth = screenWidth - MAIN_IMAGEVIEW_MARGIN * 2;
        
        //设置标题文字和描述文字的内容和尺寸
        self.titleLabel.text = cellItem.contents.title;
        self.descLabel.text = cellItem.contents.desc;
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainImageView);
            make.right.equalTo(self.mainImageView);
            make.top.equalTo(self.mainImageView.bottom).offset(TITLELABEL_TO_MAINIMAGEVIEW_MARGIN);
        }];
        [self.descLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.bottom).offset(DESCLABEL_TO_TITLELABEL_MARGIN);
        }];
        [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.descLabel.bottom).offset(SEPERATORVIEW_TOP_MARGIN);
            make.height.equalTo(SEPERATORVIEW_HEIGHT);
        }];

    }
    //1
    else if (cellItem.contents.image.url.length && cellItem.contents.title_1st.length && cellItem.contents.title_2nd.length) {
//        ATLog(@"1   ------------    %@",cellItem.contents.title_1st);
        
        //添加子控件
        //添加并设置大图
        [self setMainImageViewWithCellItem:cellItem];
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = ATSeparatorBackgroundColor;
        [self.contentView addSubview:separatorView];
        self.separatorView = separatorView;
        
        [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.mainImageView.bottom).offset(SEPERATORVIEW_TOP_MARGIN);
            make.height.equalTo(SEPERATORVIEW_HEIGHT);
        }];
        
    }
    //5
    else if (cellItem.contents.image.url.length && cellItem.contents.whisper.length) {
//        ATLog(@"5");
        //添加子控件
        //添加并设置大图
        [self setMainImageViewWithCellItem:cellItem];
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = ATSeparatorBackgroundColor;
        [self.contentView addSubview:separatorView];
        self.separatorView = separatorView;
        
        [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.mainImageView.bottom).offset(SEPERATORVIEW_TOP_MARGIN);
            make.height.equalTo(SEPERATORVIEW_HEIGHT);
        }];
    }
    //6
    else if (cellItem.contents.image.url.length) {
//        ATLog(@"6");
        //添加子控件
        //添加并设置大图
        [self setMainImageViewWithCellItem:cellItem];
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = ATSeparatorBackgroundColor;
        [self.contentView addSubview:separatorView];
        self.separatorView = separatorView;
        
        [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.mainImageView.bottom).offset(SEPERATORVIEW_TOP_MARGIN);
            make.height.equalTo(SEPERATORVIEW_HEIGHT);
        }];
        
    }
    //4
    else if (cellItem.contents.title.length && cellItem.contents.n_discussions && !(cellItem.contents.image.url.length)) {
//        ATLog(@"4");
        
        ATLabel *titleLabel = [[ATLabel alloc] init];
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        ATLabel *answerPersonsLabel = [[ATLabel alloc] init];
        answerPersonsLabel.textColor = [UIColor lightGrayColor];
        answerPersonsLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:answerPersonsLabel];
        self.answerPersonsLabel = answerPersonsLabel;
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = ATSeparatorBackgroundColor;
        [self.contentView addSubview:separatorView];
        self.separatorView = separatorView;
        
        // 应该始终要加上这一句,不然在6/6plus上就不准确了
        self.titleLabel.preferredMaxLayoutWidth = screenWidth - MAIN_IMAGEVIEW_MARGIN * 2;

        self.titleLabel.text = cellItem.contents.title;
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(MAIN_IMAGEVIEW_MARGIN);
            make.right.equalTo(self.contentView).offset(-MAIN_IMAGEVIEW_MARGIN);
            make.top.equalTo(self.contentView).offset(MAIN_IMAGEVIEW_MARGIN);
        }];
        self.answerPersonsLabel.text = [NSString stringWithFormat:@"%ld个回答",cellItem.contents.n_discussions];
        [self.answerPersonsLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.bottom).offset(SCORELABEL_TOP_TO_DESCLABEL);
        }];
    
        [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.answerPersonsLabel.bottom).offset(SEPERATORVIEW_TOP_MARGIN);
            make.height.equalTo(SEPERATORVIEW_HEIGHT);
        }];

    }
    //-1 (意外情况)
    else {
        ATLog(@"-1");
    }
}

@end