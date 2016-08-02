//
//  ScreenListModel.h
//  ProjectB
//
//  Created by lanouhn on 15/7/21.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScreenListModel : NSObject

@property (nonatomic, copy) NSString *Id, *title, *img, *Description, *time, *price, *mycollect;
@property (nonatomic, strong) NSMutableArray *type;

@end
