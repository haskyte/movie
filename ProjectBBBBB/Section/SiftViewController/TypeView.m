//
//  TypeView.m
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/23.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "TypeView.h"


#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@implementation TypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDE, SCREENHEIGHT/2)];
        view.backgroundColor = [UIColor redColor];
        
        [self addSubview:view];
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT/2, SCREENWIDE, self.bounds.size.height - view.bounds.size.height)];
        view1.backgroundColor = [UIColor blackColor];
        view1.alpha = 0.3;
        [self addSubview:view1];
        
        
    }
    return self;
}


@end
