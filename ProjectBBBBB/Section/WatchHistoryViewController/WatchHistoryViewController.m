//
//  WatchHistoryViewController.m
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/26.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "WatchHistoryViewController.h"
#import "WatchHistory.h"
#import "HistoryTableViewCell.h"
#import "AppDelegate.h"
#import "PlayViewController.h"
#import "VideoModel.h"
#import "PlayDramaViewController.h"
#import "MBProgressHUD.h"

@interface WatchHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,HistoryTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *footLabel;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation WatchHistoryViewController

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [@[] mutableCopy];
    }
    return _dataArray;
}
- (IBAction)returnToPlayVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 创建请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"WatchHistory"];
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    NSArray *array = [appdelegate.managedObjectContext executeFetchRequest:request error:nil] ;
    self.dataArray = [NSMutableArray arrayWithArray:array];

    [self.view addSubview:self.tabelView];
    if (self.dataArray.count == 0) {
        UILabel *fotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDE, 20)];
        fotLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        fotLabel.font = [UIFont systemFontOfSize:14];
        fotLabel.text = @"没有数据哦😁";
        fotLabel.textAlignment = NSTextAlignmentCenter;
        self.tabelView.tableFooterView = fotLabel;
    }else{
        self.footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDE, 20)];
        self.footLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        self.footLabel.font = [UIFont systemFontOfSize:14];
        self.footLabel.text = @"没有更多辣😝";
        self.footLabel.textAlignment = NSTextAlignmentCenter;
        self.tabelView.tableFooterView = self.footLabel;
    }
    
    
    
}

- (UITableView *)tabelView{
    if (_tabelView == nil) {
        self.tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDE, SCREENHEIGHT) style:UITableViewStylePlain];
        
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
    }
    return _tabelView;
}


#pragma mark tableView delegate & dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"historyCell";
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.tag = indexPath.row +101;
        cell.delegate = self;
        
    }
    cell.watchHistory = self.dataArray[indexPath.row];
    return cell;
}

//// 删除历史记录
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除上下文里面的数据
        AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
        [appdelegate.managedObjectContext deleteObject:self.dataArray[indexPath.row]];
        // 删除数据源里面的数据
        [self.dataArray removeObjectAtIndex:indexPath.row];
        // 删除cell
        [self.tabelView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)postDeleteCellAtIndexPath:(NSIndexPath *)indexPath{
    // 删除上下文里面的数据
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [appdelegate.managedObjectContext deleteObject:self.dataArray[indexPath.row]];
    // 删除数据源里面的数据
    [self.dataArray removeObjectAtIndex:indexPath.row];
    // 删除cell
    [self.tabelView reloadData];
}


// 返回cell 的尺寸
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREENWIDE/4 + 20;
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WatchHistory *watchHistory = self.dataArray[indexPath.row];

    if ([watchHistory.maxepisode isEqualToString:@"(null)"]) {
        [self performSegueWithIdentifier:@"historyPushToVideoPlay" sender:watchHistory.videoID];
    }else{
        VideoModel *videoModel = [[VideoModel alloc] init];
        videoModel.Id = watchHistory.videoID;
        [self performSegueWithIdentifier:@"historyPushToDramaPlay" sender:videoModel];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 删除全部；
- (IBAction)chooseItemToDelete:(id)sender {
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.mode = MBProgressHUDModeDeterminate;
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
    NSMutableArray *array1 = [@[] mutableCopy];
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [appdelegate.managedObjectContext deleteObject:obj];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        [array1 addObject:indexPath];
    }];
    [self.dataArray removeAllObjects];
    [self.tabelView deleteRowsAtIndexPaths:array1 withRowAnimation:UITableViewRowAnimationTop];
    
    UILabel *fotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDE, 20)];
    fotLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    fotLabel.font = [UIFont systemFontOfSize:14];
    fotLabel.text = @"没有数据哦😁";
    fotLabel.textAlignment = NSTextAlignmentCenter;
    self.tabelView.tableFooterView = fotLabel;
    [self.HUD hide:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"historyPushToVideoPlay"]) {
        PlayViewController *playVC = segue.destinationViewController;
        playVC.videoId = sender;
    }else if ([segue.identifier isEqualToString:@"historyPushToDramaPlay"]){
        PlayDramaViewController *playDramaVC = segue.destinationViewController;
        playDramaVC.videoModel = sender;
    }

    
}


@end
