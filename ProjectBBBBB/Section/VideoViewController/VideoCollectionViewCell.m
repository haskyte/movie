//
//  VideoCollectionViewCell.m
//  ProjectB
//
//  Created by lanouhn on 15/7/21.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "VideoCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "VideoModel.h"
#import "WatchHistory.h"

#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface VideoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *photoImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *decLabel;

@end


@implementation VideoCollectionViewCell

- (UIImageView *)photoImage{
    if (_photoImage == nil) {
        self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREENWIDE-50)/3, SCREENWIDE/2 - 50)];

    }
    return _photoImage;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREENWIDE/2 - 45, (SCREENWIDE-50)/3, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:14];


    }
    return _nameLabel;
}
- (UILabel *)decLabel{
    if (_decLabel == nil) {
        self.decLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREENWIDE/2 - 25, (SCREENWIDE-50)/3, 25)];
        _decLabel.font = [UIFont systemFontOfSize:10];
        _decLabel.numberOfLines = 2;
        _decLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    }
    return _decLabel;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.photoImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.decLabel];
        
    }
    return self;
}

- (void)setVideoModel:(VideoModel *)videoModel{
    if (_videoModel != videoModel) {
        _videoModel = videoModel;
    }
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",videoModel.img]]];
    self.nameLabel.text = videoModel.title;
    self.decLabel.text = videoModel.Description;

}

- (void)setWatchHistory:(WatchHistory *)watchHistory{
    if (_watchHistory != watchHistory) {
        _watchHistory = watchHistory;
    }
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",watchHistory.img]]];
    self.nameLabel.text = watchHistory.title;
    self.decLabel.text = watchHistory.descript;
    
    
}


@end
