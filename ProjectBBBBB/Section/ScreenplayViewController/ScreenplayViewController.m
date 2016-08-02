//
//  ScreenplayViewController.m
//  ProjectB
//
//  Created by lanouhn on 15/7/20.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "ScreenplayViewController.h"
#import "AFNetworking.h"
#import "ScreenplayPhotoModel.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "ScreenListModel.h"
#import "ScreenPlayTableViewCell.h"
#import "SiftViewController.h"
#import "ScreenPlayInforViewController.h"

#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
@interface ScreenplayViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectScreenplayButton;
@property (weak, nonatomic) IBOutlet UIButton *findOutScreenplayButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 滚动视图 和数据源
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) UIImageView *photoImage;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *idArray;
// tableView列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ScreenplayViewController

- (NSMutableArray *)photoArray{
    if (_photoArray == nil) {
        self.photoArray = [[NSMutableArray alloc] init];
    }
    return _photoArray;
}
- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        self.titleArray = [@[] mutableCopy];
    }
    return _titleArray;
}
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [@[] mutableCopy];
    }
    return _dataArray;
}
- (NSMutableArray *)idArray{
    if (_idArray == nil) {
        self.idArray = [@[] mutableCopy];
    }
    return _idArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置button的边框颜色
    self.selectScreenplayButton.layer.borderWidth = 0.5;
    self.selectScreenplayButton.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    self.findOutScreenplayButton.layer.borderWidth = 0.5;
    self.findOutScreenplayButton.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    
    // 请求滚动视图数据
    [self getPhotoImageNetWorkRequest];
    // 请求tableView列表数据
    [self getTableDataRequest];
}

- (void)getPhotoImageNetWorkRequest{
    NSString *url = [NSString stringWithFormat:@"http://api2.jxvdy.com/focus_pic?name=screenplay"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self getPhotoDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@",error);
        
    }];
    [operation start];
}
// 数据请求成功
- (void)getPhotoDataSuccessWithObject:(id)object{
    NSArray *array = object;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ScreenplayPhotoModel *screenPlayModel = [[ScreenplayPhotoModel alloc] init];
        [screenPlayModel setValuesForKeysWithDictionary:obj];
        [self.photoArray addObject:screenPlayModel.img];
        [self.titleArray addObject:screenPlayModel.title];
        [self.idArray addObject:screenPlayModel.Id];
    }];

    [self.tableView reloadData];
}

// 请求tableView列表数据
- (void)getTableDataRequest{
    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=screenplay&attr=2&count=15&order=time&dirction=1&offset=0"]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:requset success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self getTabelViewDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"列表数据 请求失败 %@",error);
    }];
    [operation start];
}
// tableView 数据请求成功；

- (void)getTabelViewDataSuccessWithObject:(id)object{
    NSArray *array = object;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ScreenListModel *listModel = [[ScreenListModel alloc] init];
        [listModel setValuesForKeysWithDictionary:obj];
        [self.dataArray addObject:listModel];
    }];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectScreenplayButton:(id)sender {
    [self performSegueWithIdentifier:@"screenPlayPushToSift" sender:@"screenplay"];
}
- (IBAction)findOutScreenplayButton:(id)sender {
    NSString *str = [NSString stringWithFormat:@"%d",arc4random()%3000];
    [self performSegueWithIdentifier:@"screenPlayInfo" sender:str];
}
- (IBAction)screenPlayPushToSearch:(id)sender {
    [self performSegueWithIdentifier:@"ScreenPlayPushToSearch" sender:self];
}

#pragma tableView datasource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return nil;
    }else{
        static NSString *identifier = @"screenplayCell";
        ScreenPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ScreenPlayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.listModel = self.dataArray[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 0;
    }else{
        return SCREENWIDE/4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return SCREENWIDE/2;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDE, SCREENWIDE/2) imageURLStringsGroup:self.photoArray];

    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.titlesGroup = self.titleArray;
    _scrollView.delegate = self;
    return _scrollView;
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ScreenListModel *listModel = self.dataArray[indexPath.row];
    [self performSegueWithIdentifier:@"screenPlayInfo" sender:listModel.Id];
}
// 点击滚动视图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [self performSegueWithIdentifier:@"screenPlayInfo" sender:self.idArray[index]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"screenPlayPushToSift"]) {
        SiftViewController *siftVC = segue.destinationViewController;
        siftVC.modelName = sender;
    }else if ([segue.identifier isEqualToString:@"screenPlayInfo"] ){
        ScreenPlayInforViewController *screenInforVC = segue.destinationViewController;
        screenInforVC.inforID = sender;
    }
    
}


@end
