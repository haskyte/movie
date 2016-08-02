//
//  DramaCollectionReusableView.h
//  ProjectB
//
//  Created by lanouhn on 15/7/22.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;
@protocol DramaCollectionReusableViewDelegate <NSObject>

- (void)postInforWithVideoModel:(VideoModel *)videoModel;

@end


@interface DramaCollectionReusableView : UICollectionReusableView

@property (nonatomic, weak) id<DramaCollectionReusableViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
