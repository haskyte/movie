//
//  VideoViewController.m
//  ProjectB
//
//  Created by lanouhn on 15/7/20.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoScrollCollectionReusableView.h"
#import "ListCollectionReusableView.h"
#import "VideoCollectionViewCell.h"
#import "AFNetworking.h"
#import "VideoModel.h"
#import "SearchViewController.h"
#import "SiftViewController.h"
#import "PlayViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "WatchHistory.h"
#import "SVProgressHUD.h"

#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface VideoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,VideoScrollCollectionResuableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *chooseVideo;
@property (weak, nonatomic) IBOutlet UIButton *findVideo;

@property (nonatomic, strong) UICollectionView *collectionView;

// 数据源
@property (nonatomic, strong) NSMutableArray *introduceArray;
@property (nonatomic, strong) NSMutableArray *countryArray;
@property (nonatomic, strong) NSMutableArray *foreignArray;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation VideoViewController

- (NSMutableArray *)introduceArray{
    if (_introduceArray == nil) {
        self.introduceArray = [@[] mutableCopy];
    }
    return _introduceArray;
}
- (NSMutableArray *)countryArray{
    if (_countryArray == nil) {
        self.countryArray = [@[] mutableCopy];
    }
    return _countryArray;
}
- (NSMutableArray *)foreignArray{
    if (_foreignArray == nil) {
        self.foreignArray = [@[] mutableCopy];
    }
    return _foreignArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    // 设置button的边框颜色
    self.chooseVideo.layer.borderWidth = 0.5;
    self.chooseVideo.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    self.findVideo.layer.borderWidth = 0.5;
    self.findVideo.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    
    // 创建collectionView；
    [self.view addSubview:self.collectionView];
    
    // 进行网络请求
    
    [self getIntroduceDataRequest];
    [self getCountryDataRequest];
    [self getForeignDataRequest];
    
}
// 请求推荐作品数据
- (void)getIntroduceDataRequest{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=video&count=6&order=time&direction=1&attr=2"]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
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
    [self.HUD hide:YES];
    [self.collectionView reloadData];
    
}

// 请求国内作品数据
- (void)getCountryDataRequest{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=video&zone=23&order=random&count=6&attr=2"]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self getCountryDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    [operation start];
}
- (void)getCountryDataSuccessWithObject:(id)object{
    [self.countryArray removeAllObjects];
    NSArray *array = object;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        VideoModel *videoModel = [[VideoModel alloc] init];
        [videoModel setValuesForKeysWithDictionary:obj];
        [self.countryArray addObject:videoModel];
    
    }];
    [self.collectionView reloadData];
}

// 请求国外作品数据
- (void)getForeignDataRequest{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=video&zone=24&order=random&count=6&attr=2"]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self getForeignDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
}
- (void)getForeignDataSuccessWithObject:(id)object{
    [self.foreignArray removeAllObjects];
    NSArray *array = object;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        VideoModel *videoModel = [[VideoModel alloc] init];
        [videoModel setValuesForKeysWithDictionary:obj];
        [self.foreignArray addObject:videoModel];
    }];
    [self.collectionView reloadData];

}

// 创建collectionView
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + SCREENWIDE/10, SCREENWIDE, SCREENHEIGHT - (64 + SCREENWIDE/10 + 50)) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        // 注册区头
        [_collectionView registerClass:[VideoScrollCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"scrollheader"];
        [_collectionView registerClass:[ListCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"listheader"];
        // 注册cell
        [_collectionView registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:@"videoitem"];
        
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma collection datasouce & delegate

// 返回分区的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
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
        cell.videoModel = self.countryArray[indexPath.row];
    }else if (indexPath.section == 3){
        cell.videoModel = self.foreignArray[indexPath.row];
    }
    return cell;
}


// 返回分区的 区头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            VideoScrollCollectionReusableView *scrollHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"scrollheader" forIndexPath:indexPath];
            scrollHeader.delegate = self;
            return scrollHeader;
        }else{
            ListCollectionReusableView *listHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"listheader" forIndexPath:indexPath];
            NSArray *array = [NSArray arrayWithObjects:@"佳作推荐",@"国内作品",@"国外作品", nil];
            listHeader.nameLabel.text = array[indexPath.section - 1];
            return listHeader;
        }
    }
    return nil;
}
// 代理方法
- (void)postScrollViewUrlID:(NSString *)urlID{
    [self performSegueWithIdentifier:@"videoPushToPlay" sender:urlID];
}


// 返回分区的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SCREENWIDE, SCREENWIDE/2);
    }else{
        return CGSizeMake(SCREENWIDE, 30);
    }
}
// 返回item 的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREENWIDE - 50)/3, SCREENWIDE/2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoModel *videoModel = [[VideoModel alloc] init];
    if (indexPath.section == 1) {
        videoModel = self.introduceArray[indexPath.row];
    }else if (indexPath.section == 2){
        videoModel = self.countryArray[indexPath.row];
    }else if (indexPath.section == 3){
        videoModel = self.foreignArray[indexPath.row];
    }
    [self performSegueWithIdentifier:@"videoPushToPlay" sender:videoModel.Id];
    
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

- (IBAction)ChooseVideoAction:(id)sender {
    [self performSegueWithIdentifier:@"pushToSift" sender:@"video"];
}
- (IBAction)FindVideoAction:(id)sender {
    [self performSegueWithIdentifier:@"videoPushToPlay" sender:[NSString stringWithFormat:@"%d",arc4random()%3000]];
}
- (IBAction)pushToSearchVC:(id)sender {
    [self performSegueWithIdentifier:@"pushToSearch" sender:nil];
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"pushToSift"]) {
        SiftViewController *siftVC = segue.destinationViewController;
        siftVC.modelName = sender;
    }else if ([segue.identifier isEqualToString:@"videoPushToPlay"]){
        PlayViewController *playVC = segue.destinationViewController;
        playVC.videoId = sender;
    }
    
}


@end
