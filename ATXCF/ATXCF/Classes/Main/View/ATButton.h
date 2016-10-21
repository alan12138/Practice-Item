//
//  ATButton.h
//  ATXCF
//
//  Created by 谷士雄 on 16/9/28.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ATButtonStyle) {
    ATButtonStyleLeftImageRightTitle,
    ATButtonStyleLeftTitleRightImage,
    ATButtonStyleUpImageDownTitle,
    ATButtonStyleUpTitleDownImage
};
typedef void (^ATButtonTap)(void);
@interface ATButton : UIView
/// 布局方式
@property (nonatomic, assign) ATButtonStyle buttonStyle;
/// 图片和文字的间距
@property (nonatomic, assign) CGFloat padding;

//图片高度
@property (nonatomic, assign) CGFloat imageViewHeight;
//图片宽度
@property (nonatomic, assign) CGFloat imageViewWidth;
//标题字体
@property (nonatomic, assign) CGFloat titleFontSize;
//标题颜色
@property (nonatomic, strong) UIColor *titleColor;
//点击回调
@property (nonatomic, copy) ATButtonTap tap;

- (void)setTitle:(NSString *)title;
- (void)setImage:(UIImage *)image;
- (void)setImageURL:(NSURL *)url;
@end
