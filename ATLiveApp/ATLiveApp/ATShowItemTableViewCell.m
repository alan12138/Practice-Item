//
//  ATShowItemTableViewCell.m
//  ATLiveApp
//
//  Created by 张伟 on 2020/1/3.
//  Copyright © 2020 张伟. All rights reserved.
//

#import "ATShowItemTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ATShowItem.h"

@interface ATShowItemTableViewCell ()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLabel;
@end

@implementation ATShowItemTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NSString *ID = @"ATShowItemTableViewCell";
    ATShowItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ATShowItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setItem:(ATShowItem *)item {
    _item = item;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:item.photo]];
    self.nameLabel.text = item.nickname;
}

- (void)setupUI {
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 300 - 70, [UIScreen mainScreen].bounds.size.width, 70)];
    nameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
}
@end
