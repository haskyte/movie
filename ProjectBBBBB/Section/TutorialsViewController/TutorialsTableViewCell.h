//
//  TutorialsTableViewCell.h
//  ProjectB
//
//  Created by lanouhn on 15/7/21.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TuorialsModel;

@interface TutorialsTableViewCell : UITableViewCell

@property (nonatomic, strong) TuorialsModel *tuorialsModel;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
