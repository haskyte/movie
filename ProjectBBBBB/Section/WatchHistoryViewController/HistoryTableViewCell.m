//
//  HistoryTableViewCell.m
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/28.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "WatchHistory.h"
#import "UIImageView+WebCache.h"
#import "LikedList.h"

@interface HistoryTableViewCell ()

@property (nonatomic, strong) UIImageView *photoImage;
@property (nonatomic, strong) UILabel *titlelabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@end


@implementation HistoryTableViewCell

- (UIImageView *)photoImage{
    if (_photoImage == nil) {
        self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, (SCREENWIDE - 50)/6, SCREENWIDE/4)];
        
    }
    return _photoImage;
}

- (UILabel *)titlelabel{
    if (_titlelabel == nil) {
        self.titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + (SCREENWIDE - 50)/6, 10, SCREENWIDE/2, SCREENWIDE/12)];
        
    }
    return _titlelabel;
}

- (UILabel *)scoreLabel{
    if (_scoreLabel == nil) {
        self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + (SCREENWIDE - 50)/6, 10 + SCREENWIDE/12, SCREENWIDE/2, SCREENWIDE/12)];
        _scoreLabel.font = [UIFont systemFontOfSize:15];
    }
    return _scoreLabel;
}
- (UILabel *)desLabel{
    if (_desLabel == nil) {
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + (SCREENWIDE - 50)/6, 10 + SCREENWIDE/6, (SCREENWIDE - 30 - (SCREENWIDE - 50)/6), SCREENWIDE/12)];
        _desLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        _desLabel.font = [UIFont systemFontOfSize:14];
        _desLabel.numberOfLines = 2;
    }
    return _desLabel;
}

- (UIButton *)deleteButton{
    if (_deleteButton == nil) {
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteButton.frame = CGRectMake(SCREENWIDE - 30,10, 20, 20);
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"search_icon_delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (void)deleteButtonAction:(UIButton *)button{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tag - 101 inSection:0];
    [self.delegate postDeleteCellAtIndexPath:indexPath];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.photoImage];
        [self.contentView addSubview:self.titlelabel];
        [self.contentView addSubview:self.scoreLabel];
        [self.contentView addSubview:self.desLabel];
        [self.contentView addSubview:self.deleteButton];
        
    }
    return self;
}

- (void)setWatchHistory:(WatchHistory *)watchHistory{
    if (_watchHistory != watchHistory) {
        _watchHistory = watchHistory;
    }
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",watchHistory.img]]];
    self.titlelabel.text = [NSString stringWithFormat:@"《%@》",watchHistory.title];
    self.scoreLabel.text = [NSString stringWithFormat:@"评分：%@",watchHistory.score];
    self.desLabel.text = watchHistory.descript;
    
}

- (void)setLikeList:(LikedList *)likeList{
    if (_likeList != likeList) {
        _likeList = likeList;
    }
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",likeList.img]]];
    self.titlelabel.text = [NSString stringWithFormat:@"《%@》",likeList.title];
    self.scoreLabel.text = [NSString stringWithFormat:@"评分：%@",likeList.score];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-d HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:likeList.time];
    self.desLabel.text = [NSString stringWithFormat:@"收藏时间:%@",dateStr];
    
}




@end
