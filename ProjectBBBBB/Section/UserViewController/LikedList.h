//
//  LikedList.h
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/29.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LikedList : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * descript;
@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSString * img;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * videoID;

@end
