//
//  VideoScrollCollectionReusableView.m
//  ProjectB
//
//  Created by ; on 15/7/21.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "VideoScrollCollectionReusableView.h"
#import "SDCycleScrollView.h"
#import "AFNetworking.h"
#import "ScreenplayPhotoModel.h"

#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface VideoScrollCollectionReusableView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *idArray;

@end

@implementation VideoScrollCollectionReusableView

- (NSMutableArray *)photoArray{
    if (_photoArray == nil) {
        self.photoArray = [@[] mutableCopy];
    }
    return _photoArray;
}
- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        self.titleArray = [@[] mutableCopy];
    }
    return _titleArray;
}

- (NSMutableArray *)idArray{
    if (_idArray == nil) {
        self.idArray = [@[] mutableCopy];
    }
    return _idArray;
}

- (SDCycleScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDE, SCREENWIDE/2)];
        _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _scrollView.delegate = self;
        [self getScrollPhotoNetWorkRequest];
    }
    return _scrollView;
}

// 进行网络请求
- (void)getScrollPhotoNetWorkRequest{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/focus_pic?name=video"]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self getDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"video scroll get net work fail");
    }];
    [operation start];
}
// 请求成功
- (void)getDataSuccessWithObject:(id)object{
    NSArray *array = object;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ScreenplayPhotoModel *scrollModel = [[ScreenplayPhotoModel alloc] init];
        [scrollModel setValuesForKeysWithDictionary:obj];
        [self.photoArray addObject:scrollModel.img];
        [self.titleArray addObject:scrollModel.title];
        [self.idArray addObject:scrollModel.Id];
    }];
    self.scrollView.imageURLStringsGroup = self.photoArray;
    self.scrollView.titlesGroup = self.titleArray;
    [self reloadInputViews];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [self.delegate postScrollViewUrlID:self.idArray[index]];
}

@end
