//
//  PlayInforTableViewCell.m
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/24.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "PlayInforTableViewCell.h"
#import "PlayModel.h"

#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SPACE 0
@interface PlayInforTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *directorsLabel;
@property (nonatomic, strong) UILabel *writersLabel;
@property (nonatomic, strong) UILabel *actLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *zoneLabel;
@property (nonatomic, strong) UILabel *yearLabel;

@end

@implementation PlayInforTableViewCell

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 , SCREENWIDE, 0)];
    }
    return _nameLabel;
}


// 描述
- (UILabel *)desLabel{
    if (!_desLabel) {
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, SPACE, SCREENWIDE - 20, 0)];
        _desLabel.numberOfLines = 0;
        _desLabel.font = [UIFont systemFontOfSize:15];
        _desLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _desLabel;
}
// 导演
- (UILabel *)directorsLabel{
    if (!_directorsLabel) {
        self.directorsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 + 2 * SPACE , SCREENWIDE, 0)];
        _directorsLabel.font = [UIFont systemFontOfSize:14];
    }
    return _directorsLabel;
}
// 编剧
- (UILabel *)writersLabel{
    if (!_writersLabel) {
        self.writersLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 + 0 + 3* SPACE , SCREENWIDE, 0)];
        _writersLabel.font = [UIFont systemFontOfSize:14];
    }
    return _writersLabel;
}
// 主演
- (UILabel *)actLabel{
    if (!_actLabel) {
        self.actLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 + 0 + 0 + 4*SPACE , SCREENWIDE, 0)];
        _actLabel.font = [UIFont systemFontOfSize:14];
        _actLabel.numberOfLines = 0;
    }
    return _actLabel;
}
// 类型
- (UILabel *)typeLabel{
    if (!_typeLabel) {
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 + 0 +0 +0 + 5*SPACE , SCREENWIDE, 30)];
        _typeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _typeLabel;
}
// 地区
- (UILabel *)zoneLabel{
    if (!_zoneLabel) {
        self.zoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 + 0 + 0 +0 + 6 * SPACE + 30 , SCREENWIDE, 30)];
        _zoneLabel.font = [UIFont systemFontOfSize:14];
    }
    return _zoneLabel;
}
// 年份
- (UILabel *)yearLabel{
    if (!_yearLabel) {
        self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 + 0 + 0 +0 + 7*SPACE + 60, SCREENWIDE, 30)];
        _yearLabel.font = [UIFont systemFontOfSize:14];
    }
    return _yearLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.desLabel];
        [self.contentView addSubview:self.directorsLabel];
        [self.contentView addSubview:self.writersLabel];
        [self.contentView addSubview:self.actLabel];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.zoneLabel];
        [self.contentView addSubview:self.yearLabel];
        
    }
    return self;
}

-(void)setPlayModel:(PlayModel *)playModel{
    if (_playModel != playModel) {
        _playModel = playModel;
    }
    


    self.nameLabel.text = [NSString stringWithFormat:@"%@    评分：%@",playModel.title,playModel.score];
    self.nameLabel.frame = CGRectMake(10, 10, SCREENWIDE, 20);
    
    CGRect desRect = [playModel.Description boundingRectWithSize:CGSizeMake(SCREENWIDE - 20, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    self.desLabel.text = playModel.Description;
    self.desLabel.frame = CGRectMake(10,30+ SPACE, SCREENWIDE-20, desRect.size.height);
    
    CGRect direRect = [playModel.directors boundingRectWithSize:CGSizeMake(SCREENWIDE, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.directorsLabel.text = [NSString stringWithFormat:@"导演：%@",playModel.directors];
    if ([playModel.directors isEqualToString:@""]) {
        direRect.size.height = 0;
        self.directorsLabel.text = @"";
    }
    self.directorsLabel.frame = CGRectMake(10, 30 + desRect.size.height + 2 * SPACE , SCREENWIDE, direRect.size.height);
    
    
    CGRect writRect = [playModel.writers  boundingRectWithSize:CGSizeMake(SCREENWIDE, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.writersLabel.text = [NSString stringWithFormat:@"编剧：%@",playModel.writers];
    if ([playModel.writers isEqualToString:@""]) {
        writRect.size.height = 0;
        self.writersLabel.text = @"";
    }
    self.writersLabel.frame = CGRectMake(10, 30+desRect.size.height + direRect.size.height + 3*SPACE, SCREENWIDE, writRect.size.height);
    
    CGRect actRect = [playModel.actors boundingRectWithSize:CGSizeMake(SCREENWIDE - 20, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.actLabel.text = [NSString stringWithFormat:@"演员：%@",playModel.actors];
    if (playModel.actors.length == 0) {
        actRect.size.height = 0;
        self.actLabel.text = @"";
    }
    self.actLabel.frame = CGRectMake(10,30+ desRect.size.height + direRect.size.height + writRect.size.height + 4 * SPACE, SCREENWIDE - 20, actRect.size.height);
    
    NSArray *typeArray = playModel.type;
    NSString *str = [NSString stringWithFormat:@"类型：%@",typeArray.firstObject];
    for (int i = 1; i < typeArray.count ; i ++) {
        str = [NSString stringWithFormat:@"%@/%@",str,typeArray[i]];
    }
    self.typeLabel.text = str;
    self.typeLabel.frame = CGRectMake(10, 30+desRect.size.height + direRect.size.height + writRect.size.height + actRect.size.height + 5 * SPACE, SCREENWIDE, 20);
    self.zoneLabel.text = [NSString stringWithFormat:@"地区：%@",playModel.zone];
    self.zoneLabel.frame = CGRectMake(10,30+ desRect.size.height + direRect.size.height + writRect.size.height + actRect.size.height + 6 * SPACE + 20, SCREENWIDE, 20);
    self.yearLabel.text = [NSString stringWithFormat:@"年份：%@",playModel.year];
    self.yearLabel.frame = CGRectMake(10,30+ desRect.size.height + direRect.size.height + writRect.size.height + actRect.size.height + 7 * SPACE + 20 + 20, SCREENWIDE, 20);
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
