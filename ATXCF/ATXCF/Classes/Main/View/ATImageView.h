//
//  ATImageView.h
//  ATXCF
//
//  Created by 谷士雄 on 16/9/29.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ATImageViewStyle) {
    ATImageViewStylePicAndString,
    ATImageViewStyleStringAndString,
    ATImageViewStyleNone
};

typedef void (^ATImageViewTap)(void);

@interface ATImageView : UIView
/// 布局方式
@property (nonatomic, assign) ATImageViewStyle imageViewStyle;
//点击回调
@property (nonatomic, copy) ATImageViewTap tap;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *subImage;
@property (nonatomic, copy) NSString *downLabelStr;
@property (nonatomic, copy) NSString *upLabelStr;

@property (nonatomic, assign) CGFloat upLabelFontSize;
@property (nonatomic, assign) CGFloat downLabelFontSize;

@property (nonatomic, assign) BOOL upLabelBold;
@property (nonatomic, assign) BOOL downLabelBold;

@property (nonatomic, strong) UIColor *upLabelColor;
@property (nonatomic, strong) UIColor *downLabelColor;
- (void)setMainImageURL:(NSURL *)url;
- (void)setSubImageURL:(NSURL *)url;
@end
