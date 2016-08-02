//
//  AboutTableViewCell.h
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/24.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>


// 自定义代理
@protocol AboutTableViewCellDelegate <NSObject>

- (void)getVideoId:(NSString *)VideoID;

@end


@interface AboutTableViewCell : UITableViewCell

@property (nonatomic,weak) id<AboutTableViewCellDelegate>delegate;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withVideoID:(NSString *)videoID related:(NSString *)related;

@end
