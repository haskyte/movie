//
//  HistoryTableViewCell.h
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/28.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WatchHistory;
@class LikedList;
@protocol  HistoryTableViewCellDelegate <NSObject>

- (void)postDeleteCellAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic, strong) WatchHistory *watchHistory;

@property (nonatomic, strong) LikedList *likeList;
@property (nonatomic, weak) id<HistoryTableViewCellDelegate>delegate;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
