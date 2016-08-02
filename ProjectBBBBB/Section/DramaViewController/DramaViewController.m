//
//  DramaViewController.m
//  ProjectB
//
//  Created by lanouhn on 15/7/20.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "DramaViewController.h"
#import "VideoCollectionViewCell.h"
#import "ListCollectionReusableView.h"
#import "DramaCollectionReusableView.h"
#import "VideoModel.h"
#import "AFNetworking.h"
#import "SiftViewController.h"
#import "PlayDramaViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "WatchHistory.h"

#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@interface DramaViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DramaCollectionReusableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *chooseDrama;
@property (weak, nonatomic) IBOutlet UIButton *findDrama;

@property (nonatomic, strong) UICollectionView *collectionView;

// 数据源
@property (nonatomic, strong) NSMutableArray *introduceArray;
@property (nonatomic, strong) NSMutableArray *newsArray;

@property (nonatomic,strong) MBProgressHUD *HUD;

@end

@implementation DramaViewController


- (NSMutableArray *)introduceArray{
    if (_introduceArray == nil) {
        self.introduceArray = [@[] mutableCopy];
    }
    return _introduceArray;
}
- (NSMutableArray *)newsArray{
    if (_newsArray == nil) {
        self.newsArray = [@[] mutableCopy];
    }
    return _newsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.chooseDrama.layer.borderWidth = 0.5;
    self.chooseDrama.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    self.findDrama.layer.borderWidth = 0.5;
    self.findDrama.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    // 创建collectionView；
    [self.view addSubview:self.collectionView];
    // 进行网络请求
    [self getIntroduceDataRequest];
    [self getNewsDataRequest];
    
    
}
// 请求推荐作品数据
- (void)getIntroduceDataRequest{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=drama&count=6&order=time&direction=1"]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        [self.HUD show:YES];
        [self getIntroduceDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
}
- (void)getIntroduceDataSuccessWithObject:(id)object{
    [self.introduceArray removeAllObjects];
    NSArray *array = object;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        VideoModel *videoModel = [[VideoModel alloc] init];
        [videoModel setValuesForKeysWithDictionary:obj];
        [self.introduceArray addObject:videoModel];
    }];
    [self.collectionView reloadData];
    [self.HUD hide:YES];
}

// 请求国内作品数据
- (void)getNewsDataRequest{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=drama&order=random&attr=2&count=6"]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self getNewsDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
}
- (void)getNewsDataSuccessWithObject:(id)object{
    [self.newsArray removeAllObjects];
    NSArray *array = object;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        VideoModel *videoModel = [[VideoModel alloc] init];
        [videoModel setValuesForKeysWithDictionary:obj];
        [self.newsArray addObject:videoModel];
        
    }];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,  SCREENWIDE/10, SCREENWIDE, SCREENHEIGHT - (SCREENWIDE/10 )) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        // 注册区头
        [_collectionView registerClass:[DramaCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"scrollheader"];
        [_collectionView registerClass:[ListCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"listheader"];
        // 注册cell
        [_collectionView registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:@"videoitem"];
        
    }
    return _collectionView;
}
#pragma mark collection datasouce & delegate

// 返回分区的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
// 返回item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return self.introduceArray.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoitem" forIndexPath:indexPath];
    if (indexPath.section == 1) {
        cell.videoModel = self.introduceArray[indexPath.row];
    }else if (indexPath.section == 2){
        cell.videoModel = self.newsArray[indexPath.row];
    }
    return cell;
}
// 返回分区的 区头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            DramaCollectionReusableView *scrollHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"scrollheader" forIndexPath:indexPath];
            scrollHeader.delegate = self;
            return scrollHeader;
        }else{
            ListCollectionReusableView *listHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"listheader" forIndexPath:indexPath];
            NSArray *array = [NSArray arrayWithObjects:@"最近更新",@"佳作推荐", nil];
            listHeader.nameLabel.text = array[indexPath.section - 1];
            return listHeader;
        }
    }
    return nil;
}

// 返回分区的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SCREENWIDE, SCREENWIDE/2);
    }else{
        return CGSizeMake(SCREENWIDE, 30);
    }
}
//cell 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoModel *videoModel = [[VideoModel alloc] init];
    
    if (indexPath.section == 1) {
        videoModel = self.introduceArray[indexPath.row];
    }else if (indexPath.section == 2){
        videoModel = self.newsArray[indexPath.row];
    }
    [self performSegueWithIdentifier:@"DramaModelToPlay" sender:videoModel];
    
    
    // 创建实体描述
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    
    
    // 查询所有video title的数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"WatchHistory"];
    request.predicate = [NSPredicate predicateWithFormat:@"title=%@",videoModel.title];
    NSArray *array = [appdelegate.managedObjectContext executeFetchRequest:request error:nil];
    if (array.count == 0) {
        NSEntityDescription *descript = [NSEntityDescription entityForName:@"WatchHistory" inManagedObjectContext:appdelegate.managedObjectContext];
        WatchHistory *watchHistory = [[WatchHistory alloc] initWithEntity:descript insertIntoManagedObjectContext:appdelegate.managedObjectContext];
        watchHistory.videoID = [NSString stringWithFormat:@"%@",videoModel.Id];
        watchHistory.title = videoModel.title;
        watchHistory.img = videoModel.img;
        watchHistory.score = [NSString stringWithFormat:@"%@",videoModel.score];
        watchHistory.descript = videoModel.Description;
        watchHistory.time = [NSString stringWithFormat:@"%@",videoModel.time];
        watchHistory.maxepisode = [NSString stringWithFormat:@"%@",videoModel.maxepisode];
        watchHistory.maxid = [NSString stringWithFormat:@"%@",videoModel.maxid];
        watchHistory.introduction = videoModel.introduction;
    }else{
        
    }

    
}

// 滚动视图代理方法
- (void)postInforWithVideoModel:(VideoModel *)videoModel{
    [self performSegueWithIdentifier:@"DramaModelToPlay" sender:videoModel];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREENWIDE - 50)/3, SCREENWIDE/2);
}

- (IBAction)chooseDramaAction:(id)sender {
    [self performSegueWithIdentifier:@"dramaPushToSift" sender:@"drama"];
}
- (IBAction)selectDramaAction:(id)sender {
    VideoModel *videoModel;
    videoModel = self.newsArray[arc4random()%5];
    [self performSegueWithIdentifier:@"DramaModelToPlay" sender:videoModel];
}
- (IBAction)pushToSearchVC:(id)sender {
    [self performSegueWithIdentifier:@"DramaPushToSearch" sender:nil];
}
- (IBAction)pushToHistoryVC:(id)sender {
    [self performSegueWithIdentifier:@"DramaPushToWatchHistory" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"dramaPushToSift"]) {
        SiftViewController *siftVC = segue.destinationViewController;
        siftVC.modelName = sender;
    }else if ([segue.identifier isEqualToString:@"DramaModelToPlay"]){
        PlayDramaViewController *playDramaVC =segue.destinationViewController;
        playDramaVC.videoModel = sender;
    }

}


@end
