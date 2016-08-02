//
//  PlayInforTableViewCell.h
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/24.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayModel;
@interface PlayInforTableViewCell : UITableViewCell

@property (nonatomic, strong) PlayModel *playModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
