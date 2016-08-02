//
//  ScreenPlayTableViewCell.m
//  ProjectB
//
//  Created by lanouhn on 15/7/21.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "ScreenPlayTableViewCell.h"
#import "ScreenListModel.h"
#import "UIImageView+WebCache.h"

#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define PHOTOHEIGHT (SCREENWIDE/4 - 20)

@interface ScreenPlayTableViewCell ()

@property (nonatomic, strong) UIImageView *photoImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end


@implementation ScreenPlayTableViewCell

- (UIImageView *)photoImage{
    if (_photoImage == nil) {
        self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, SCREENWIDE/4, PHOTOHEIGHT)];
    }
    return _photoImage;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + SCREENWIDE/4, 10, SCREENWIDE - SCREENWIDE/4 - 35 , PHOTOHEIGHT*2/3)];
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UILabel *)typeLabel{
    if (_typeLabel == nil) {
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + SCREENWIDE/4, 10 + PHOTOHEIGHT*2/3, SCREENWIDE/2, PHOTOHEIGHT/3)];
        _typeLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        _typeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _typeLabel;
}

- (UILabel *)priceLabel{
    if (_priceLabel == nil) {
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDE - 20 - SCREENWIDE/4, 10 + PHOTOHEIGHT*2/3, SCREENWIDE/4, PHOTOHEIGHT/3)];
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.textColor = [UIColor orangeColor];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.photoImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.priceLabel];
    }
    return self;
}

// 重写model setter方法；
- (void)setListModel:(ScreenListModel *)listModel{
    if (_listModel != listModel) {
        _listModel = listModel;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",listModel.img]];
    [self.photoImage sd_setImageWithURL:url];
    self.nameLabel.text = [NSString stringWithFormat:@"《%@》%@",listModel.title,listModel.Description];
    CGFloat price = [listModel.price floatValue];
    if (price == -1) {
        self.priceLabel.text = [NSString stringWithFormat:@"议价"];
    }else if (price == 0){
        self.priceLabel.text = @"";
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"%@",listModel.price];
    }
    
    NSArray *typeArray = listModel.type;
    NSString *str = [NSString stringWithFormat:@"%@",typeArray.firstObject];
    for (int i = 1; i < typeArray.count ; i ++) {
        str = [NSString stringWithFormat:@"%@/%@",str,typeArray[i]];
    }
    self.typeLabel.text = str;
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
