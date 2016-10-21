//
//  ATSearchBar.m
//  ATXCF
//
//  Created by 谷士雄 on 16/9/23.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATSearchBar.h"

@interface ATSearchBar ()

@end

@implementation ATSearchBar 

+ (ATSearchBar *)searchBarWithPlaceholder:(NSString *)placeholder {
    ATSearchBar *searchBar = [[ATSearchBar alloc] init];
    searchBar.placeholder = placeholder;
    //设置搜索框的内部背景色
    UIView *searchBarSubView = searchBar.subviews[0];
    for (UIView *subView in searchBarSubView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            [subView setBackgroundColor:ATSearchBarBackgroundColor];
        }
    }
    return searchBar;

}
@end
