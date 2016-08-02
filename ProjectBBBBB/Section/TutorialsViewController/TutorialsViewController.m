//
//  TutorialsViewController.m
//  ProjectB
//
//  Created by lanouhn on 15/7/20.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "TutorialsViewController.h"
#import "SDCycleScrollView.h"
#import "AFNetworking.h"
#import "ScreenplayPhotoModel.h"
#import "TuorialsModel.h"
#import "TutorialsTableViewCell.h"

#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface TutorialsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic, strong) UIScrollView *buttonScroll;
@property (nonatomic, strong) UIButton *button;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *dataArray;
// 滚动图片
@property (nonatomic, strong) SDCycleScrollView *scrollView;

@property (nonatomic, copy) NSString *urlString;

@end

@implementation TutorialsViewController

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
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [@[] mutableCopy];
    }
    return _dataArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selectButton.layer.borderWidth = 0.5;
    self.selectButton.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addButtonOnScrollView];
    // 请求滚动视图数据
    [self getPhotoImageNetWorkRequest];
    //
    self.urlString = @"attr=2&count=15";
    [self getTableDataRequest];
}
- (void)getPhotoImageNetWorkRequest{
    self.tableView.sectionHeaderHeight = SCREENWIDE/2;
    NSString *url = [NSString stringWithFormat:@"http://api2.jxvdy.com/focus_pic?name=tutorials"];
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
    [self.photoArray removeAllObjects];
    [self.titleArray removeAllObjects];
    NSArray *array = object;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ScreenplayPhotoModel *screenPlayModel = [[ScreenplayPhotoModel alloc] init];
        [screenPlayModel setValuesForKeysWithDictionary:obj];
        [self.photoArray addObject:screenPlayModel.img];
        [self.titleArray addObject:screenPlayModel.title];
    }];
    
    [self.tableView reloadData];
}

- (void)addButtonOnScrollView{
    self.buttonScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDE * 2 / 3, SCREENWIDE / 10)];
    self.buttonScroll.contentSize = CGSizeMake(SCREENWIDE/ 3 * 5, SCREENWIDE/10);
    self.buttonScroll.alwaysBounceVertical = NO;
    self.buttonScroll.layer.borderWidth = 0.5;
    self.buttonScroll.pagingEnabled = YES;
    self.buttonScroll.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    self.buttonScroll.showsHorizontalScrollIndicator = NO;
    NSArray *array = [NSArray arrayWithObjects:@"推荐教程",@"剧作教程",@"微影拍摄",@"影视后期",@"拍摄器材", nil];
    
    for (int i = 0 ; i < 5; i ++) {
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake(SCREENWIDE / 3 * i, 0, SCREENWIDE/3, SCREENWIDE/10);
        [self.buttonScroll addSubview:_button];
        [_button setTitle:array[i] forState:UIControlStateNormal];
        _button.tag = 101+i;
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:self.buttonScroll];
}
// 点击事件
- (void)buttonAction:(UIButton *)button{
    switch (button.tag) {
        case 101:
            self.urlString = @"attr=2&count=15";
            [self getTableDataRequest];
            // 请求滚动视图数据
            [self getPhotoImageNetWorkRequest];
            break;
        case 102:
            self.urlString = @"count=15&token=(null)&type=14";
            [self getTableDataRequest];
            self.tableView.sectionHeaderHeight = 0;
            break;
        case 103:
            self.urlString = @"count=15&token=(null)&type=15";
            self.tableView.sectionHeaderHeight = 0;
            [self getTableDataRequest];
            break;
        case 104:
            self.urlString = @"count=15&token=(null)&type=16";
            self.tableView.sectionHeaderHeight = 0;
            [self getTableDataRequest];
            break;
        case 105:
            self.urlString = @"count=15&token=(null)&type=17";
            self.tableView.sectionHeaderHeight = 0;
            [self getTableDataRequest];
            break;
        default:
            break;
    }
}

// 请求tableView列表数据
- (void)getTableDataRequest{
    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=tutorials&%@&order=time&dirction=1&offset=0",self.urlString]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:requset success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self getTabelViewDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"列表数据 请求失败 %@",error);
    }];
    [operation start];
}
// tableView 数据请求成功；

- (void)getTabelViewDataSuccessWithObject:(id)object{
    [self.dataArray removeAllObjects];
    NSArray *array = object;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TuorialsModel *tuorialsModel = [[TuorialsModel alloc] init];
        [tuorialsModel setValuesForKeysWithDictionary:obj];
        [self.dataArray addObject:tuorialsModel];
    }];
    [self.tableView reloadData];
    
}

#pragma tableView delegate & datasource

// 返回分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"tuorialsCell";
    TutorialsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TutorialsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tuorialsModel = self.dataArray[indexPath.row];
    return cell;
}
// 返回行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREENWIDE/4;
}

//返回区头高度
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return SCREENWIDE/2;
//}

// 自定义区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDE, SCREENWIDE/2) imageURLStringsGroup:self.photoArray];
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.titlesGroup = self.titleArray;
    return _scrollView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    // 创建scrollView和button；
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
