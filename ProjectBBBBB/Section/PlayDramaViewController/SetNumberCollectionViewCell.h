//
//  SetNumberCollectionViewCell.h
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/25.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayModel;
@interface SetNumberCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) PlayModel *playModel;
- (instancetype)initWithFrame:(CGRect)frame;

@end
