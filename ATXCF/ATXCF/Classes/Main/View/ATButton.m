//
//  ATButton.m
//  ATXCF
//
//  Created by 谷士雄 on 16/9/28.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATButton.h"
#import "UIImageView+webCache.h"

@interface ATButton ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) ATLabel *titleLabel;
@end

@implementation ATButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        ATLabel *titleLabel= [[ATLabel alloc] init];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClick)];
        [self addGestureRecognizer:tap];
        //默认模式
        self.buttonStyle = ATButtonStyleLeftImageRightTitle;
    }
    
    return self;
}
- (void)setPadding:(CGFloat)padding {
    _padding = padding;
    [self sizeToFit];
}
- (void)setImageViewWidth:(CGFloat)imageViewWidth {
    _imageViewWidth = imageViewWidth;
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(imageViewWidth);
    }];
}
- (void)setImageViewHeight:(CGFloat)imageViewHeight {
    _imageViewHeight = imageViewHeight;
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(imageViewHeight);
    }];
}
- (void)setTitleFontSize:(CGFloat)titleFontSize {
    _titleFontSize = titleFontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
    [self sizeToFit];
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}
- (void)setTitle:(NSString *)title
{
    [self.titleLabel setText:title];
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image
{
    [self.imageView setImage:image];
    [self sizeToFit];
}
- (void)setImageURL:(NSURL *)url {
    [self.imageView sd_setImageWithURL:url placeholderImage:nil];
    [self sizeToFit];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    switch (self.buttonStyle) {
        case ATButtonStyleLeftImageRightTitle:
            [self layoutHorizontalWithLeftView:self.imageView rightView:self.titleLabel];
            break;
        case ATButtonStyleLeftTitleRightImage:
            [self layoutHorizontalWithLeftView:self.titleLabel rightView:self.imageView];
            break;
        case ATButtonStyleUpImageDownTitle:
            [self layoutVerticalWithUpView:self.imageView downView:self.titleLabel];
            break;
        case ATButtonStyleUpTitleDownImage:
            [self layoutVerticalWithUpView:self.titleLabel downView:self.imageView];
            break;
        default:
            break;
    }
}

- (void)layoutHorizontalWithLeftView:(UIView *)leftView rightView:(UIView *)rightView {

    [leftView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];

    [rightView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.right).offset(self.padding);
        make.centerY.equalTo(self);
    }];
}

- (void)layoutVerticalWithUpView:(UIView *)upView downView:(UIView *)downView {
    [upView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];
    [downView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView.bottom).offset(self.padding);
        make.centerX.equalTo(self);
    }];
}
- (void)buttonClick {
    if (self.tap) {
        self.tap();
    }
}

@end
