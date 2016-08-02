//
//  SiftViewController.m
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/23.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "SiftViewController.h"
#import "TypeView.h"
#import "VideoCollectionViewCell.h"
#import "AFNetworking.h"
#import "VideoModel.h"
#import "ScreenListModel.h"
#import "ScreenPlayTableViewCell.h"
#import "ScreenPlayInforViewController.h"
#import "PlayViewController.h"
#import "PlayDramaViewController.h"
#import "AppDelegate.h"
#import "WatchHistory.h"


#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface SiftViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *newsButton;
@property (weak, nonatomic) IBOutlet UIButton *hotButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;

@property (nonatomic, strong) TypeView *typeView;

// 数据源
@property (nonatomic, strong) NSMutableArray *collectionArray;
@property (nonatomic, strong) NSMutableArray *tableArray;

// 拼接url
@property (nonatomic, copy) NSString *orderUrl;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SiftViewController

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREENWIDE/10 , SCREENWIDE, SCREENHEIGHT - SCREENWIDE/10 ) collectionViewLayout:flowLayout];
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:@"siftCell"];
    }
    return _collectionView;
}
- (NSMutableArray *)collectionArray{
    if (_collectionArray == nil) {
        self.collectionArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _collectionArray;
}
// 懒加载tableView
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREENWIDE/10, SCREENWIDE, SCREENHEIGHT - SCREENWIDE/10 ) style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
    }
    return _tableView;
}
// 初始化数据源
- (NSMutableArray *)tableArray{
    if (_tableArray == nil) {
        self.tableArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _tableArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackBarButton"] style:UIBarButtonItemStyleDone target:self action:@selector(returnToRootViewController:)];
    [self changeButtonStyle];
    // 添加collectionView
    if ([self.modelName isEqualToString:@"video"] | [self.modelName isEqualToString:@"drama"]) {
        [self.view addSubview:self.collectionView];
    }else if ([self.modelName isEqualToString:@"screenplay"]){
        [self.view addSubview:self.tableView];
    }
    
    // 添加弹出视图
    self.typeView = [[TypeView alloc] initWithFrame:CGRectMake(0, -self.view.bounds.size.height + 64 +SCREENWIDE/10, self.view.bounds.size.width, self.view.bounds.size.height - 104)];
    [self.view addSubview:self.typeView];

    // 进行网络请求
    self.orderUrl = @"time";
    [self getNetWorkRequest];
}



// 修改button的样式
- (void)changeButtonStyle{
    self.newsButton.layer.borderWidth = 0.5;
    self.newsButton.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    self.hotButton.layer.borderWidth = 0.5;
    self.hotButton.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    self.goodButton.layer.borderWidth = 0.5;
    self.goodButton.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    self.typeButton.layer.borderWidth = 0.5;
    self.typeButton.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    
}
// 返回上一个界面
- (void)returnToRootViewController:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)newsButtonAction:(id)sender {
    self.orderUrl = @"time";
    [self getNetWorkRequest];
}
- (IBAction)hotButtonAction:(id)sender {
    self.orderUrl = @"hits";
    [self getNetWorkRequest];
}
- (IBAction)goodButtonAction:(id)sender {
    self.orderUrl = @"like";
    [self getNetWorkRequest];
}
- (IBAction)typeButtonAction:(UIButton *)sender {
    if (sender.selected == NO) {
        
        sender.selected = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint center = self.typeView.center;
            center.y += SCREENHEIGHT;
            self.typeView.center = center;
        }];
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint center = self.typeView.center;
            center.y -= SCREENHEIGHT;
            self.typeView.center = center;
        }];
        sender.selected = NO;
    }
}

// 进行网络请求
- (void)getNetWorkRequest{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=%@&order=%@&count=15&offset=0&type=0",self.modelName,self.orderUrl]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self.tableArray removeAllObjects];
        [self getNetWorkRequestSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
}
- (void)getNetWorkRequestSuccessWithObject:(id)object{
    [self.collectionArray removeAllObjects];
    [self.tableArray removeAllObjects];
    NSArray *array = object;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        VideoModel *videoModel = [[VideoModel alloc]init];
        [videoModel setValuesForKeysWithDictionary:obj];
        
        [self.collectionArray addObject:videoModel];
        
        ScreenListModel *listModel =[[ScreenListModel alloc] init];
        [listModel setValuesForKeysWithDictionary:obj];
        [self.tableArray addObject:listModel];
    }];
    
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

#pragma collection dataSource & delegate
// 返回item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionArray.count;
}

// 返回item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"siftCell" forIndexPath:indexPath];
    cell.videoModel = self.collectionArray[indexPath.row];
    return cell;
}

// 返回item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREENWIDE - 50)/3, SCREENWIDE/2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoModel *videoModel = self.collectionArray[indexPath.row];
    if ([self.modelName isEqualToString:@"video"]) {
        [self performSegueWithIdentifier:@"SiftToPlay" sender:videoModel.Id];
    }else if ([self.modelName isEqualToString:@"drama"]){
        [self performSegueWithIdentifier:@"SiftModelToDarmaPlay" sender:videoModel];
    }
    
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

#pragma tableView dataSource & delegtate

// 返回cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"tableCell";
    ScreenPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ScreenPlayTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.listModel = self.tableArray[indexPath.row];
    return cell;
}
// 返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREENWIDE/4;
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ScreenListModel *listModel = self.tableArray[indexPath.row];
    [self performSegueWithIdentifier:@"siftPushToScreenInfor" sender:listModel.Id];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"siftPushToScreenInfor"]) {
        ScreenPlayInforViewController *screenInforVC = segue.destinationViewController;
        screenInforVC.inforID = sender;
    }else if ([segue.identifier isEqualToString:@"SiftToPlay"]){
        PlayViewController *playVC = segue.destinationViewController;
        playVC.videoId = sender;
    }else if ([segue.identifier isEqualToString:@"SiftModelToDarmaPlay"]){
        PlayDramaViewController *playDramaVC = segue.destinationViewController;
        playDramaVC.videoModel = sender;
    }
}


@end
