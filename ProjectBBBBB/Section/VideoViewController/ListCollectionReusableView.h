//
//  ListCollectionReusableView.h
//  ProjectB
//
//  Created by lanouhn on 15/7/21.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *nameLabel;

-(instancetype)initWithFrame:(CGRect)frame;

@end
