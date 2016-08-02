//
//  SetNumberTableViewCell.m
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/25.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "SetNumberTableViewCell.h"
#import "SetNumberCollectionViewCell.h"
#import "PlayModel.h"
#import "AFNetworking.h"

@interface SetNumberTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SetNumberTableViewCell

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [@[] mutableCopy];
    }
    return _dataArray;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withVideoID:(NSString *)videoID{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREENWIDE/2, 20)];
        titleLabel.text = @"选集：";
        [self.contentView addSubview:titleLabel];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, SCREENWIDE, 70) collectionViewLayout:flowLayout];
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[SetNumberCollectionViewCell class] forCellWithReuseIdentifier:@"setNumber"];
        // 设置水平方向滚动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 不显示水平滚动条
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self getNetWorkRequestWith:videoID];
        [self.contentView addSubview: self.collectionView];
    }
    return self;
}
// 请求数据
- (void)getNetWorkRequestWith:(NSString *)videoID{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/drama_info?id=%@&token=(null)",videoID]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self getTableViewDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
}
- (void)getTableViewDataSuccessWithObject:(id)object{
    [self.dataArray removeAllObjects];
    PlayModel *playModel = [[PlayModel alloc] init];
    [playModel setValuesForKeysWithDictionary:object];
    [self.dataArray addObject:playModel];
    [self.collectionView reloadData];
}

#pragma make collectionView dataSource & delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    PlayModel *playModel = [self.dataArray firstObject];
    return [playModel.maxepisode integerValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PlayModel *playModel = [self.dataArray firstObject];
    NSArray *array = playModel.episodes;
    SetNumberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"setNumber" forIndexPath:indexPath];
    cell.numLabel.text = [NSString stringWithFormat:@"%@",array[indexPath.row]];
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    view1.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    cell.selectedBackgroundView = view1;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(50, 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PlayModel *playModel = [self.dataArray firstObject];
    NSArray *array = playModel.episodes;
    [self.delegete postSetNumberWithNumber:array[indexPath.row]];
}

@end
