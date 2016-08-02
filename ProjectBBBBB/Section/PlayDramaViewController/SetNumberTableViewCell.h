//
//  SetNumberTableViewCell.h
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/25.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SetNumberTableViewCellDelegate <NSObject>

- (void)postSetNumberWithNumber:(NSString *)setNumber;

@end

@interface SetNumberTableViewCell : UITableViewCell

@property (nonatomic, weak) id<SetNumberTableViewCellDelegate>delegete;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withVideoID:(NSString *)videoID;

@end
