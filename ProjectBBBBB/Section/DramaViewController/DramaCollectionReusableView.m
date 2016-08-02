//
//  DramaCollectionReusableView.m
//  ProjectB
//
//  Created by lanouhn on 15/7/22.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "DramaCollectionReusableView.h"
#import "SDCycleScrollView.h"
#import "AFNetworking.h"
#import "ScreenplayPhotoModel.h"
#import "VideoModel.h"

#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface DramaCollectionReusableView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *IdArray;

@end


@implementation DramaCollectionReusableView

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
- (NSMutableArray *)IdArray{
    if (_IdArray == nil) {
        self.IdArray = [@[] mutableCopy];
    }
    return _IdArray;
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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/focus_pic?name=drama"]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self getDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"drama scroll get net work fail");
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
        [self.IdArray addObject:scrollModel.Id];
    }];
    self.scrollView.imageURLStringsGroup = self.photoArray;
    self.scrollView.titlesGroup = self.titleArray;
    [self reloadInputViews];
}
// 点击cell
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    NSString *str1 = [self.titleArray[index] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    /// 假数据
    NSArray *array = [NSArray arrayWithObjects:@"屌丝男士第四季",@"憨牛哈C幺第一季",@"异形庇护所第3季", nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=drama&keywords=%@&count=1&token=(null)",[array[index] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    AFJSONRequestOperation *operation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self getScrollDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
}

- (void)getScrollDataSuccessWithObject:(id)object{
    NSArray *array = object;
    NSDictionary *dic = [array firstObject];
    VideoModel *videoModel = [[VideoModel alloc] init];
    [videoModel setValuesForKeysWithDictionary:dic];
    // 代理回调
    [self.delegate postInforWithVideoModel:videoModel];
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
    }
    return self;
}

@end
