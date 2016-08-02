//
//  ScreenPlayInforViewController.m
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/23.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "ScreenPlayInforViewController.h"
#import "AFNetworking.h"
#import "ScreenPlayInforModel.h"

#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ScreenPlayInforViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ScreenPlayInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getNetWorkRequest];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackBarButton"] style:UIBarButtonItemStyleDone target:self action:@selector(returnToSearchViewController:)];
    self.tableView.tableFooterView = [UIView new];
}
// 返回上一个界面
- (void)returnToSearchViewController:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [@[] mutableCopy];
    }
    return _dataArray;
}

// 进行网络请求
- (void)getNetWorkRequest{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/screenplay_info?id=%@&token=(null)",self.inforID]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self getDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
}
// 请求成功
- (void)getDataSuccessWithObject:(id)object{
    NSDictionary *dic = object;
    ScreenPlayInforModel *screenPlayModel = [[ScreenPlayInforModel alloc] init];
    [screenPlayModel setValuesForKeysWithDictionary:dic];
    [self.dataArray addObject:screenPlayModel];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma tableView delegate & dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScreenPlayInforModel *cellModel = [self.dataArray firstObject];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        return nil;
    }else if (indexPath.section == 1){
        
        cell.textLabel.text = cellModel.synopsis;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }else if (indexPath.section == 2){
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"1cell"];
        cell.textLabel.text = cellModel.content;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }else{
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"2cell"];
        cell.textLabel.text = cellModel.character;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ScreenPlayInforModel *cellModel = [self.dataArray firstObject];
//    if (indexPath.section == 0) {
//        return 0;
//    }else if (indexPath.section == 1){
//        CGRect rect1 = [cellModel.synopsis boundingRectWithSize:CGSizeMake(SCREENWIDE, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
//        return rect1.size.height + 40;
//    }else if (indexPath.section == 2){
//        CGRect rect1 = [cellModel.content boundingRectWithSize:CGSizeMake(SCREENWIDE, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
//        return rect1.size.height + 500;
//    }else if (indexPath.section ==3){
//        CGRect rect1 = [cellModel.character boundingRectWithSize:CGSizeMake(SCREENWIDE, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
//        return rect1.size.height + 40;
//    }else{
//        return 0;
//    }
//}


// 自定义区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        ScreenPlayInforModel *screenModel = [self.dataArray firstObject];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREENWIDE - 20, 10)];
        UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20 + 10, SCREENWIDE - 20, 10)];
        desLabel.text = screenModel.Description;
        desLabel.numberOfLines = 0;
        desLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        desLabel.font = [UIFont systemFontOfSize:14];
        CGRect size1 = [desLabel.text boundingRectWithSize:CGSizeMake(SCREENWIDE, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        desLabel.frame = CGRectMake(10, 20 + 10, SCREENWIDE - 20, size1.size.height);
        
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30 + size1.size.height +10, (SCREENWIDE - 30)/2, 20)];
        typeLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        typeLabel.font = [UIFont systemFontOfSize:14];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + (SCREENWIDE - 30)/2+5, 30 + size1.size.height +10, (SCREENWIDE - 20)/2, 20)];
        timeLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        timeLabel.font = [UIFont systemFontOfSize:14];
        
        UILabel *timeLong = [[UILabel alloc] initWithFrame:CGRectMake(10, 40+10+size1.size.height+20, (SCREENWIDE - 30)/2, 20)];
        timeLong.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        timeLong.font = [UIFont systemFontOfSize:14];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + (SCREENWIDE - 30)/2 +5, 40+size1.size.height+10+20, (SCREENWIDE - 20)/2, 20)];
        priceLabel.textColor = [UIColor orangeColor];
        priceLabel.font = [UIFont systemFontOfSize:14];
        
        titleLabel.text = screenModel.title;
        
        NSArray *typeArray = screenModel.type;
        NSString *str = [NSString stringWithFormat:@"类型：%@",typeArray.firstObject];
        for (int i = 1; i < typeArray.count ; i ++) {
            str = [NSString stringWithFormat:@"%@/%@",str,typeArray[i]];
        }
        typeLabel.text = str;
        timeLabel.text = [NSString stringWithFormat:@"时代：%@",screenModel.year];
        if ([screenModel.timelong isEqualToString:@"0"]) {
            timeLong.text = @"时长：XX";
        }else{
            timeLong.text = [NSString stringWithFormat:@"时长：%@分钟",screenModel.timelong];
        }
        
        CGFloat price = [screenModel.price floatValue];
        if (price == -1) {
            priceLabel.text = [NSString stringWithFormat:@"议价"];
        }else if (price == 0){
            priceLabel.text = @"";
        }else{
            priceLabel.text = [NSString stringWithFormat:@"%@",screenModel.price];
        }
        
        UIView *headView = [[UIView alloc] init];
        headView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        [headView addSubview:titleLabel];
        [headView addSubview:desLabel];
        [headView addSubview:typeLabel];
        [headView addSubview:timeLong];
        [headView addSubview:timeLabel];
        [headView addSubview:priceLabel];
        return headView;
    }else if(section == 1){
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        label.text = @" 故事梗概";
        return label;
    }else if(section == 2){
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        label.text = @" 剧本正文";
        return label;
    }else{
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        label.text = @" 人物介绍";
        return label;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    ScreenPlayInforModel *screenModel = [self.dataArray firstObject];
    CGRect rect = [screenModel.Description boundingRectWithSize:CGSizeMake(SCREENWIDE, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    if (section == 0) {
        return rect.size.height + 100;
    }else{
        return 30;
    }
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
