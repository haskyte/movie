//
//  VideoCollectionViewCell.h
//  ProjectB
//
//  Created by lanouhn on 15/7/21.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;
@class WatchHistory;
@interface VideoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) WatchHistory *watchHistory;

@property (nonatomic, strong) VideoModel *videoModel;
- (instancetype)initWithFrame:(CGRect)frame;

@end
