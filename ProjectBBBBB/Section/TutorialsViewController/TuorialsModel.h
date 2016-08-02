//
//  TuorialsModel.h
//  ProjectB
//
//  Created by lanouhn on 15/7/21.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TuorialsModel : NSObject

@property (nonatomic, copy) NSString *Id, *title, *img, *time, *mycollect;
@property (nonatomic, strong) NSMutableArray *type;

@end
