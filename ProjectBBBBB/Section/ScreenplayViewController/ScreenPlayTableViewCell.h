//
//  ScreenPlayTableViewCell.h
//  ProjectB
//
//  Created by lanouhn on 15/7/21.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScreenListModel;
@interface ScreenPlayTableViewCell : UITableViewCell

@property (nonatomic, strong) ScreenListModel *listModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
