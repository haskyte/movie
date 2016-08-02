//
//  AboutTableViewCell.m
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/24.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "AboutTableViewCell.h"
#import "AFNetworking.h"
#import "VideoModel.h"
#import "VideoCollectionViewCell.h"
#import "AppDelegate.h"
#import "WatchHistory.h"

@interface AboutTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;




@end

@implementation AboutTableViewCell

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [@[] mutableCopy];
    }
    return _dataArray;
}


//- (UICollectionView *)collectionView{
//    if (!_collectionView) {
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
//        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//        
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        [_collectionView registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:@"aboutCell1"];
//        _collectionView.dataSource = self;
//        _collectionView.delegate = self;
//    }
//    return _collectionView;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withVideoID:(NSString *)videoID related:(NSString *)related{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,25, SCREENWIDE, SCREENWIDE/2 + 30) collectionViewLayout:flowLayout];
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView.backgroundColor = [UIColor whiteColor];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [_collectionView registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:@"aboutCell1"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREENWIDE - 20, 20)];
        label.text = @"相关推荐：";
        
        [self.contentView addSubview:label];
        [self.contentView addSubview:self.collectionView];
        
        [self getNetWorkRequestVideoID:videoID related:related];
    }
    return self;
}
- (void)getNetWorkRequestVideoID:(NSString *)videoID related:(NSString *)related{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/%@_related?id=%@&count=10&offset=0",related,videoID]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self getDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
}
// 请求成功
- (void)getDataSuccessWithObject:(id)object{
    [self.dataArray removeAllObjects];
    NSArray *array = object;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        VideoModel *videoModel = [[VideoModel alloc] init];
        [videoModel setValuesForKeysWithDictionary:obj];
        [self.dataArray addObject:videoModel];
        
    }];
    [self.collectionView reloadData];
}

#pragma mark  collectionView delegate & dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"aboutCell1" forIndexPath:indexPath];
    cell.videoModel = self.dataArray[indexPath.row];

    return cell;
}

// 返回item 的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREENWIDE - 50)/3, SCREENWIDE/2);
}

// 点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoModel *videoModel = self.dataArray[indexPath.row];
    [self.delegate getVideoId:videoModel.Id];
    
    // 点击播放后存储到播放历史中
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *reqest = [NSFetchRequest fetchRequestWithEntityName:@"WatchHistory"];
    NSString *str = [NSString stringWithFormat:@"%@",videoModel.Id];
    reqest.predicate = [NSPredicate predicateWithFormat:@"videoID=%@",str];
    NSArray *array = [appdelegate.managedObjectContext executeFetchRequest:reqest error:nil];
    if (array.count == 0) {
        NSEntityDescription *descript = [NSEntityDescription entityForName:@"WatchHistory" inManagedObjectContext:appdelegate.managedObjectContext];
        WatchHistory *watchHistory = [[WatchHistory alloc]initWithEntity:descript insertIntoManagedObjectContext:appdelegate.managedObjectContext];
        watchHistory.videoID = [NSString stringWithFormat:@"%@",videoModel.Id];
        watchHistory.title = videoModel.title;
        watchHistory.img = videoModel.img;
        watchHistory.score = [NSString stringWithFormat:@"%@",videoModel.score];
        watchHistory.descript = videoModel.Description;
        watchHistory.time = [NSString stringWithFormat:@"%@",videoModel.time];
        watchHistory.maxepisode = [NSString stringWithFormat:@"%@",videoModel.maxepisode];
        watchHistory.maxid = [NSString stringWithFormat:@"%@",videoModel.maxid];
        watchHistory.introduction = videoModel.introduction;
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
