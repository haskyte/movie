//
//  ResultViewController.m
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/22.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "ResultViewController.h"
#import "VideoModel.h"
#import "VideoCollectionViewCell.h"
#import "AFNetworking.h"
#import "ScreenPlayTableViewCell.h"
#import "ScreenListModel.h"
#import "ScreenPlayInforViewController.h"
#import "PlayViewController.h"
#import "PlayDramaViewController.h"
#import "AppDelegate.h"
#import "WatchHistory.h"

#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ResultViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *dramaButton;
@property (weak, nonatomic) IBOutlet UIButton *screenButton;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
// 数据源
@property (nonatomic, strong) NSMutableArray *collectionArray;
@property (nonatomic, strong) NSMutableArray *tableArray;
// 拼接网址
@property (nonatomic, strong) NSString *modelURL;
// 定义一个画布 放collectionview 和tableview
@property (nonatomic, strong) UIView *contentView;
@end

@implementation ResultViewController
// 懒加载collectionView
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDE, SCREENHEIGHT - SCREENWIDE/10) collectionViewLayout:flowLayout];
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:@"resultCell"];
    }
    return _collectionView;
}
- (NSMutableArray *)collectionArray{
    if (_collectionArray == nil) {
        self.collectionArray = [@[] mutableCopy];
    }
    return _collectionArray;
}
// 懒加载tableView
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDE, SCREENHEIGHT - SCREENWIDE/10 - 64) style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
    }
    return _tableView;
}
- (NSMutableArray *)tableArray{
    if (_tableArray == nil) {
        self.tableArray = [@[] mutableCopy];
    }
    return _tableArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENWIDE/10 , SCREENWIDE, SCREENHEIGHT - SCREENWIDE/10)];

    [self.view addSubview:self.contentView];
    
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackBarButton"] style:UIBarButtonItemStyleDone target:self action:@selector(returnToSearchViewController:)];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    // 修改button的样式
    [self changeButtonStyle];
    // 添加collectionView
    [self.contentView addSubview:self.collectionView];
    // 进行网络请求
    self.modelURL = @"video";
    [self getNetWorkRequest];
    
}
- (void)getNetWorkRequest{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=%@&keywords=%@&count=15&token=(null)&offset=0",self.modelURL,self.searchText]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
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
    [self.collectionView reloadData];
    [self.tableView reloadData];

}


// 修改button的样式
- (void)changeButtonStyle{
    self.videoButton.layer.borderWidth = 0.5;
    self.videoButton.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    self.dramaButton.layer.borderWidth = 0.5;
    self.dramaButton.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    self.screenButton.layer.borderWidth = 0.5;
    self.screenButton.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 返回搜索界面
- (void)returnToSearchViewController:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)touchVideoButton:(id)sender {
    [self.tableView removeFromSuperview];
    [self.collectionView removeFromSuperview];
    self.modelURL = @"video";
    [self.contentView addSubview:self.collectionView];
    [self getNetWorkRequest];
    
}
- (IBAction)touchDramaButton:(id)sender {
    [self.tableView removeFromSuperview];
    [self.collectionView removeFromSuperview];
    self.modelURL = @"drama";
    [self.contentView addSubview:self.collectionView];
    [self getNetWorkRequest];
}
- (IBAction)touchScreenPlayButton:(id)sender {
    [self.collectionArray removeAllObjects];
    [self.tableArray removeAllObjects];
    [self.tableView removeFromSuperview];
    [self.collectionView removeFromSuperview];
    
    self.modelURL = @"screenplay";
    [self.contentView addSubview:self.tableView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDE, 10)];
    label.text = @"没有更多了";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    self.tableView.tableFooterView = label;
    [self getNetWorkRequest];
}

#pragma collection dataSource & delegate 
// 返回item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionArray.count;
}

// 返回item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"resultCell" forIndexPath:indexPath];
    cell.videoModel = self.collectionArray[indexPath.row];
    return cell;
}

// 返回item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREENWIDE - 50)/3, SCREENWIDE/2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoModel *videoModel = self.collectionArray[indexPath.row];
    if ([self.modelURL isEqualToString:@"video"]) {
        [self performSegueWithIdentifier:@"ResultToPlay" sender:videoModel.Id];
    }else if ([self.modelURL isEqualToString:@"drama"]){
        [self performSegueWithIdentifier:@"ResultModelToDrama" sender:videoModel];
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

#pragma mark tableView dataSource & delegtate

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ScreenListModel *listModel = self.tableArray[indexPath.row];
    [self performSegueWithIdentifier:@"resultToScreenInfor" sender:listModel.Id];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"resultToScreenInfor"]) {
        ScreenPlayInforViewController *screenInforVC = segue.destinationViewController;
        screenInforVC.inforID = sender;
    }else if ([segue.identifier isEqualToString:@"ResultToPlay"]){
        PlayViewController *playVC = segue.destinationViewController;
        playVC.videoId = sender;
    }else if ([segue.identifier isEqualToString:@"ResultModelToDrama"]){
        PlayDramaViewController *playDramaVC = segue.destinationViewController;
        playDramaVC.videoModel = sender;
    }
}


@end
