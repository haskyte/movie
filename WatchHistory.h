//
//  WatchHistory.h
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/26.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WatchHistory : NSManagedObject

@property (nonatomic, retain) NSString * videoID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * img;
@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSString * descript;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * maxepisode;
@property (nonatomic, retain) NSString * maxid;
@property (nonatomic, retain) NSString * introduction;

@end
