//
//  ListCollectionReusableView.m
//  ProjectB
//
//  Created by lanouhn on 15/7/21.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "ListCollectionReusableView.h"

@implementation ListCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.bounds.size.width/2, self.bounds.size.height)];
        [self addSubview:self.nameLabel];
        UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 5, self.bounds.size.height)];
        colorLabel.backgroundColor = [UIColor blueColor];
        [self addSubview:colorLabel];
    }
    return self;
}

@end
