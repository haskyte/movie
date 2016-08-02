//
//  UserViewController.m
//  ProjectB
//
//  Created by lanouhn on 15/7/20.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "UserViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UIImageView *photoImage;
@property (nonatomic, strong) MBProgressHUD *HUD;


@property (nonatomic, strong) UITableView *tableView;


@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self creatUserPhoto];
    [self.view addSubview:self.tableView];
    
    
    
}

- (void)creatUserPhoto{
    self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDE, SCREENHEIGHT/3)];
    _backImage.backgroundColor =[UIColor redColor];
    [self.view addSubview:_backImage];
    
    self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDE/2-30, 32 + SCREENHEIGHT/6, 60, 60)];
    self.photoImage.backgroundColor = [UIColor yellowColor];
    self.photoImage.layer.cornerRadius = 30;
    self.photoImage.layer.masksToBounds = YES;
    [self.view addSubview:self.photoImage];
    
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+SCREENHEIGHT/3, SCREENWIDE, SCREENHEIGHT - 49 - 64 - SCREENHEIGHT / 3) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

#pragma mark tableView dataSource  & delegate 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = [NSString stringWithFormat:@"清除图片缓存"];
    
    NSArray *dataArray = @[@"我的收藏",@"离线缓存",str];
    NSArray *imageArray = @[@"user_center_tab_faverate",@"user_center_tab_download",@"search_icon_delete"];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.text = dataArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"userPushToLiked" sender:nil];
            break;
        case 1:
            
            break;
        case 2:
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.HUD];
            self.HUD.labelText = @"正在清理";
            [self.HUD show:YES];
            [self.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.HUD hide:YES];
                CGFloat fileSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
                NSString *str = [NSString stringWithFormat:@"本次一共清理图片缓存%.2fM",fileSize];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清理完成" message:str delegate:self cancelButtonTitle:@"好哒😘" otherButtonTitles:nil];
                [alertView show];
                [[SDImageCache sharedImageCache] clearDisk];
            });
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
