//
//  ATImageView.m
//  ATXCF
//
//  Created by 谷士雄 on 16/9/29.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATImageView.h"
#import "UIImageView+webCache.h"

@interface ATImageView ()
@property (nonatomic, weak) UIImageView *mainImageView;
@property (nonatomic, weak) UIView *upImageDownLabelView;
@property (nonatomic, weak) UIImageView *upImageView;
@property (nonatomic, weak) ATLabel *downLabel;
@property (nonatomic, weak) UIView *upLabelDescLabelView;
@property (nonatomic, weak) ATLabel *upLabel;
@end

@implementation ATImageView
- (UIImageView *)mainImageView {
    if (!_mainImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        /**
         *  图片会拉伸或者压缩以适应frame的边界:图片适应最小的边铺开显示，更大的边会超出frame，如果设置了clipsToBounds属性为YES，那么更大的边就会被截断。这样达成更好的居中显示效果。
         */
        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageView.contentMode =  UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageView.clipsToBounds  = YES;
        [self addSubview:imageView];
        _mainImageView = imageView;
    }
    return _mainImageView;
}
- (UIView *)upImageDownLabelView {
    if (!_upImageDownLabelView) {
        UIView *view = [[UIView alloc] init];
        
        UIImageView *upImageView = [[UIImageView alloc] init];
        [view addSubview:upImageView];
        self.upImageView = upImageView;
        
        ATLabel *downLabel = [[ATLabel alloc] init];
        [view addSubview:downLabel];
        self.downLabel = downLabel;

        [self addSubview:view];
        _upImageDownLabelView = view;
    }
    return _upImageDownLabelView;
}
- (UIView *)upLabelDescLabelView {
    if (!_upLabelDescLabelView) {
        UIView *view = [[UIView alloc] init];
        
        ATLabel *upLabel = [[ATLabel alloc] init];
        upLabel.textAlignment = NSTextAlignmentCenter;
        upLabel.numberOfLines = 0;
        [view addSubview:upLabel];
        self.upLabel = upLabel;
        
        ATLabel *downLabel = [[ATLabel alloc] init];
        downLabel.textAlignment = NSTextAlignmentCenter;
        downLabel.numberOfLines = 0;
        [view addSubview:downLabel];
        self.downLabel = downLabel;
        
        [self addSubview:view];
        _upLabelDescLabelView = view;
    }
    return _upLabelDescLabelView;

}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self mainImageView];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)setImageViewStyle:(ATImageViewStyle)imageViewStyle {
    _imageViewStyle = imageViewStyle;
    switch (self.imageViewStyle) {
        case ATImageViewStyleNone:
            break;
        case ATImageViewStylePicAndString:
            [self upImageDownLabelView];
            break;
        case ATImageViewStyleStringAndString:
            [self upLabelDescLabelView];
            break;
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    switch (self.imageViewStyle) {
        case ATImageViewStyleNone:
            [self layoutMainImageView];
            break;
        case ATImageViewStylePicAndString:
            [self layoutUpImageDownLabelView];
            break;
        case ATImageViewStyleStringAndString:
            [self layoutUpLabelDescLabelView];
            break;
        default:
            break;
    }

}

- (void)layoutMainImageView {
    [self.mainImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void)layoutUpImageDownLabelView {
    [self layoutMainImageView];
    CGFloat margin = 15;
    [self.upImageDownLabelView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(margin, margin, margin, margin));
    }];
    
    [self.downLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.upImageDownLabelView);
        make.bottom.equalTo(self.upImageDownLabelView);
    }];
    [self.upImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.downLabel);
        make.bottom.equalTo(self.downLabel.top).offset(-margin);
    }];
}
- (void)layoutUpLabelDescLabelView {
    [self layoutMainImageView];

    CGFloat margin = 30;
    [self.upLabelDescLabelView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(margin, margin, margin, margin));
    }];
#warning 这里这样设置其实是有点问题的，暂时先这样写
    CGFloat labelMargin = 20;
    [self.upLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.upLabelDescLabelView);
        make.right.equalTo(self.upLabelDescLabelView);
        make.centerY.equalTo(self.upLabelDescLabelView).offset(-labelMargin);
    }];
    [self.downLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.upLabelDescLabelView);
        make.right.equalTo(self.upLabelDescLabelView);
        make.centerY.equalTo(self.upLabelDescLabelView).offset(labelMargin);
    }];

}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.mainImageView.image = image;
    [self sizeToFit];
}
- (void)setSubImage:(UIImage *)subImage {
    _subImage = subImage;
    self.upImageView.image = subImage;
    [self sizeToFit];
}
- (void)setDownLabelStr:(NSString *)downLabelStr {
    _downLabelStr = downLabelStr;
    self.downLabel.text = downLabelStr;
    [self sizeToFit];
}

- (void)setUpLabelStr:(NSString *)upLabelStr {
    _upLabelStr = upLabelStr;
    self.upLabel.text = upLabelStr;
    [self sizeToFit];
}

- (void)setUpLabelFontSize:(CGFloat)upLabelFontSize {
    _upLabelFontSize = upLabelFontSize;
    self.upLabel.font = [UIFont systemFontOfSize:upLabelFontSize];
    [self sizeToFit];
}
- (void)setDownLabelFontSize:(CGFloat)downLabelFontSize {
    _downLabelFontSize = downLabelFontSize;
    self.downLabel.font = [UIFont systemFontOfSize:downLabelFontSize];
    [self sizeToFit];
}
- (void)setUpLabelBold:(BOOL)upLabelBold {
    _upLabelBold = upLabelBold;
    if (upLabelBold) {
        self.upLabel.font = [UIFont boldSystemFontOfSize:self.upLabelFontSize];
        [self sizeToFit];
    }

}

- (void)setDownLabelBold:(BOOL)downLabelBold {
    _downLabelBold = downLabelBold;
    if (downLabelBold) {
        self.downLabel.font = [UIFont boldSystemFontOfSize:self.downLabelFontSize];
        [self sizeToFit];
    }
}

- (void)setUpLabelColor:(UIColor *)upLabelColor {
    _upLabelColor = upLabelColor;
    self.upLabel.textColor = upLabelColor;
}
- (void)setDownLabelColor:(UIColor *)downLabelColor {
    _downLabelColor = downLabelColor;
    self.downLabel.textColor = downLabelColor;
}
- (void)setMainImageURL:(NSURL *)url {
    [self.mainImageView sd_setImageWithURL:url placeholderImage:nil];
    [self sizeToFit];
}
- (void)setSubImageURL:(NSURL *)url {
    [self.upImageView sd_setImageWithURL:url placeholderImage:nil];
    [self sizeToFit];
}
- (void)imageTap {
    if (self.tap) {
        self.tap();
    }
}
@end
