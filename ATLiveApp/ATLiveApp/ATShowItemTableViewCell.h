//
//  ATShowItemTableViewCell.h
//  ATLiveApp
//
//  Created by 张伟 on 2020/1/3.
//  Copyright © 2020 张伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATShowItem;

NS_ASSUME_NONNULL_BEGIN

@interface ATShowItemTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) ATShowItem *item;
@end

NS_ASSUME_NONNULL_END
