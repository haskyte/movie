//
//  ScreenPlayInforModel.h
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/23.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScreenPlayInforModel : NSObject

@property (nonatomic, copy) NSString *title, *price, *Description, *year, *synopsis, *character, *content, *timelong,*time,*pubid,*pubnick, *pubface,*mycollection,*myfavourite,*url;
@property (nonatomic, strong) NSMutableArray *type;

@end
