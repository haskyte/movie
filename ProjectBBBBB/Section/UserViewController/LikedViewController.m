//
//  LikedViewController.m
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/29.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "LikedViewController.h"
#import "AppDelegate.h"
#import "LikedList.h"
#import "HistoryTableViewCell.h"
#import "VideoModel.h"
#import "PlayDramaViewController.h"

@interface LikedViewController ()<UITableViewDataSource,UITableViewDelegate,HistoryTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *footLabel;

@end

@implementation LikedViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [@[] mutableCopy];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"LikedList"];
    NSArray *array = [appdelegate.managedObjectContext executeFetchRequest:request error:nil];
    self.dataArray = [NSMutableArray arrayWithArray:array];
    
    [self.view addSubview:self.tableView];
    [self creatFootView];
    
}

- (void)creatFootView{
    if (self.dataArray.count == 0) {
        UILabel *fotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDE, 20)];
        fotLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        fotLabel.font = [UIFont systemFontOfSize:14];
        fotLabel.text = @"没有数据哦😁";
        fotLabel.textAlignment = NSTextAlignmentCenter;
        self.tableView.tableFooterView = fotLabel;
    }else{
        self.footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDE, 20)];
        self.footLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        self.footLabel.font = [UIFont systemFontOfSize:14];
        self.footLabel.text = @"没有更多辣😝";
        self.footLabel.textAlignment = NSTextAlignmentCenter;
        self.tableView.tableFooterView = self.footLabel;
    }
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDE, SCREENHEIGHT) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
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
    cell.likeList = self.dataArray[indexPath.row];
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
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)postDeleteCellAtIndexPath:(NSIndexPath *)indexPath{
    // 删除上下文里面的数据
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [appdelegate.managedObjectContext deleteObject:self.dataArray[indexPath.row]];
    // 删除数据源里面的数据
    [self.dataArray removeObjectAtIndex:indexPath.row];
    // 删除cell
    [self.tableView reloadData];
}


// 返回cell 的尺寸
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREENWIDE/4 + 20;
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoModel *videoModel = [[VideoModel alloc] init];
    LikedList *likeList = self.dataArray[indexPath.row];
    videoModel.Id = likeList.videoID;
    [self performSegueWithIdentifier:@"LikePushToPlayDrama" sender:videoModel];
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
    if ([segue.identifier isEqualToString:@"LikePushToPlayDrama"]) {
        PlayDramaViewController *playDramaVC = segue.destinationViewController;
        playDramaVC.videoModel = sender;
    }
}


@end
