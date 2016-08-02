//
//  PlayModel.h
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/24.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayModel : NSObject

@property (nonatomic, copy) NSString *title, *Description, *score, *directors, *writers, *actors, *zone, *year, *introduction, *pubid, *pubface, *pubnick, *time, *mycollect, *url, *status, *maxepisode, *hastrailer;
@property (nonatomic, strong) NSMutableArray *type , *episodes;
@property (nonatomic, strong) NSMutableDictionary *playurl;

@end
