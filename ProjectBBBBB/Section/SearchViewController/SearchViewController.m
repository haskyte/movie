//
//  SearchViewController.m
//  ProjectB
//
//  Created by lanouhn on 15/7/22.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHistory.h"
#import "AppDelegate.h"
#import "ResultViewController.h"

#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableArray *hotArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchArray = [@[] mutableCopy];
    self.hotArray = [NSMutableArray arrayWithObjects:@"电影",@"微电影",@"拍摄",@"城市",@"故事", nil];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackBarButton"] style:UIBarButtonItemStyleDone target:self action:@selector(returnToRootViewController:)];
//    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"BackBarButton"];
    [self creatSearchBar];
    
    //创建table View
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    // 创建请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SearchHistory"];
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    // 在上下文里面 通过请求获取数据的数组
    [self.searchArray addObjectsFromArray:[appdelegate.managedObjectContext executeFetchRequest:request error:nil]];
    [self.tableView reloadData];
    
    
}

- (void)creatSearchBar{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 20, SCREENWIDE - 80 , 40)];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"输入搜索关键字";
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    

}
// 点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    // 创建实体描述对象
    NSEntityDescription *descript = [NSEntityDescription entityForName:@"SearchHistory" inManagedObjectContext:appdelegate.managedObjectContext];
    // 根据实体创建描述对象，并且将此对象添加进上下文
    SearchHistory *search = [[SearchHistory alloc] initWithEntity:descript insertIntoManagedObjectContext:appdelegate.managedObjectContext];
    search.mySearch = searchBar.text;
    [self.searchArray addObject:search];
    [self.tableView reloadData];

    [self performSegueWithIdentifier:@"pushToResult" sender:searchBar.text];
    
}
// 创建tableView;
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark tableView delegate & dateSource
// 返回分区的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
// 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.searchArray.count;
    }else if (section == 1){
        return self.hotArray.count;
    }else{
        return 0;
    }
}
// 返回分区区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDE, SCREENWIDE/10)];
    label.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    if (section == 0) {
        label.text = @"搜索历史";
    }else{
        label.text = @"热门搜索";
    }
    return label;
}
// 返回区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.searchArray.count == 0) {
            return 0;
        }else{
            return SCREENWIDE/10;
        }
    }else{
        return SCREENWIDE/10;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static  NSString *identifier = @"searchCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            SearchHistory *searchHistory = self.searchArray[indexPath.row];
            
            cell.textLabel.text = searchHistory.mySearch;
        }
        return cell;
    }else{
        static NSString *identif = @"hotCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identif];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identif];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = self.hotArray[indexPath.row];
        }
        return cell;
    }
}

// 删除历史记录
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0) {
            // 删除上下文里面的数据
            AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
            [appdelegate.managedObjectContext deleteObject:self.searchArray[indexPath.row]];
            // 删除数据源里面的数据
            [self.searchArray removeObjectAtIndex:indexPath.row];
            // 删除cell
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }else{
            [self.hotArray removeObjectAtIndex:indexPath.row];
            // 删除cell
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SearchHistory *searchHistory = self.searchArray[indexPath.row];
        [self performSegueWithIdentifier:@"pushToResult" sender:searchHistory.mySearch];
    }else{
        [self performSegueWithIdentifier:@"pushToResult" sender:self.hotArray[indexPath.row]];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 返回上一个界面
- (void)returnToRootViewController:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ResultViewController *resultVC = segue.destinationViewController;
    resultVC.searchText = [sender stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


@end
