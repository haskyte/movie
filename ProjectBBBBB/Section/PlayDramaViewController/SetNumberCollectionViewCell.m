//
//  SetNumberCollectionViewCell.m
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/25.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "SetNumberCollectionViewCell.h"

@implementation SetNumberCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.layer.borderWidth = 1;
        self.numLabel.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
        
        [self.contentView addSubview:self.numLabel];
    }
    return self;
}

-(void)setPlayModel:(PlayModel *)playModel{
    if (_playModel != playModel) {
        _playModel = playModel;
    }
    
}
@end
