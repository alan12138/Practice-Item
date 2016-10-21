//
//  UIBarButtonItem+Item.h
//  ATXCF
//
//  Created by 谷士雄 on 16/9/28.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)


+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
