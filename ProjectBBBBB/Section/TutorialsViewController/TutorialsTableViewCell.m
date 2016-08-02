//
//  TutorialsTableViewCell.m
//  ProjectB
//
//  Created by lanouhn on 15/7/21.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "TutorialsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TuorialsModel.h"


#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define PHOTOHEIGHT (SCREENWIDE/4 - 20)
@interface TutorialsTableViewCell ()

@property (nonatomic, strong) UIImageView *photoImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;

@end


@implementation TutorialsTableViewCell

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
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + SCREENWIDE/4, 10 + PHOTOHEIGHT*2/3, SCREENWIDE/4, PHOTOHEIGHT/3)];
        _typeLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        _typeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _typeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.photoImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.typeLabel];
    }
    return self;
}

- (void)setTuorialsModel:(TuorialsModel *)tuorialsModel{
    if (_tuorialsModel != tuorialsModel) {
        _tuorialsModel = tuorialsModel;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",tuorialsModel.img]];
    [self.photoImage sd_setImageWithURL:url];
    
    self.nameLabel.text = tuorialsModel.title;
    self.typeLabel.text = [NSString stringWithFormat:@"%@",tuorialsModel.type.firstObject];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
