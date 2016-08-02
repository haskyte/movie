//
//  VideoScrollCollectionReusableView.h
//  ProjectB
//
//  Created by lanouhn on 15/7/21.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoScrollCollectionResuableViewDelegate <NSObject>

- (void)postScrollViewUrlID:(NSString *)urlID;

@end


@interface VideoScrollCollectionReusableView : UICollectionReusableView

@property (nonatomic, assign) id<VideoScrollCollectionResuableViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;



@end
