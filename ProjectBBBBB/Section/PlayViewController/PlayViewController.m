//
//  PlayViewController.m
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/24.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "PlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AFNetworking.h"
#import "PlayModel.h"
#import "PlayInforTableViewCell.h"
#import "AboutTableViewCell.h"
#import "MBProgressHUD.h"

#define SCREENWIDE [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@interface PlayViewController ()<UITableViewDataSource,UITableViewDelegate,AboutTableViewCellDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 数据yuan
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) MPMoviePlayerController *player;

@property (nonatomic, strong) MBProgressHUD *HUD;

// 视频清晰度
@property (nonatomic, strong) NSString *clearStr;
@property (nonatomic,strong) UIBarButtonItem *chooseBar;

@end

@implementation PlayViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [@[] mutableCopy];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBar.alpha = 0;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    // 请求数据
    [self getNetWorkRequest];
    
    self.chooseBar = [[UIBarButtonItem alloc] initWithTitle:@"流畅" style:UIBarButtonItemStyleDone target:self action:@selector(choosePlayUrl:)];
    UIBarButtonItem *enjoyBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconSetting3"] style:UIBarButtonItemStyleDone target:self action:@selector(enjoyToFriends:)];
    
    self.navigationItem.rightBarButtonItems = @[enjoyBar, self.chooseBar];
    
}

// 点击选择清晰度
- (void)choosePlayUrl:(UIBarButtonItem *)UrlButton{
    // 添加ActionSheet
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"流畅",@"标清",@"高清", nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            self.clearStr = @"360P";
            self.chooseBar.title = @"流畅";
            [self getNetWorkRequest];
            break;
        case 1:
            self.clearStr = @"480P";
            self.chooseBar.title = @"标清";
            [self getNetWorkRequest];
            break;
        case 2:
            self.clearStr = @"720P";
            self.chooseBar.title = @"高清";
            [self getNetWorkRequest];
            break;
        default:
            break;
    }
}

// 分享
- (void)enjoyToFriends:(UIBarButtonItem *)enjoyButton{
    NSLog(@"456");
}

// 进行网络请求
- (void)getNetWorkRequest{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/video_info?token=(null)&id=%@",self.videoId]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        [self.HUD show:YES];
        [self getDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
}
// 请求成功
- (void)getDataSuccessWithObject:(id)object{
    [self.dataArray removeAllObjects];
    PlayModel *playModel = [[PlayModel alloc] init];
    [playModel setValuesForKeysWithDictionary:object];
    [self.dataArray addObject:playModel];
    [self.tableView reloadData];
    [self.HUD hide:YES];
}

//// 创建button
//- (void) creatButton{
//    self.returnButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [_returnButton setImage:[UIImage imageNamed:@"BackBarButton"] forState:UIControlStateNormal];
//    _returnButton.frame = CGRectMake(0, 20, 44, 44);
//    [_returnButton addTarget:self action:@selector(returnToRootViewController:) forControlEvents:UIControlEventTouchUpInside];
//    _returnButton.tintColor = [UIColor whiteColor];
//    [self.view addSubview:_returnButton];
//}
// 返回上一个界面

- (IBAction)returnToRootViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma tableView delegate & dateSource
// 返回分区的行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayModel *playModel = [self.dataArray firstObject];
    self.navigationItem.title = playModel.title;
        if (indexPath.row == 0) {
            static NSString *identifier = @"inforCell";
            PlayInforTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[PlayInforTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.playModel = [self.dataArray firstObject];
            return cell;
        }else if (indexPath.row == 1){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.textLabel.text = playModel.introduction;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.numberOfLines = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *identifi = @"aboutCell";
            AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
            cell.delegate = self;
            if (!cell) {
                cell = [[AboutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi withVideoID:self.videoId related:@"video"];
                
            }
            return cell;
        }
    
}

// 自定义代理方法
- (void)getVideoId:(NSString *)VideoID{
    self.videoId = VideoID;
    [self getNetWorkRequest];
}



// 返回分区的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayModel *playModel = [self.dataArray firstObject];
    if (indexPath.row == 0) {
        CGRect desRect = [playModel.Description boundingRectWithSize:CGSizeMake(SCREENWIDE - 20, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        
        CGRect direRect = [playModel.directors boundingRectWithSize:CGSizeMake(SCREENWIDE, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        CGRect writRect = [playModel.writers  boundingRectWithSize:CGSizeMake(SCREENWIDE, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        CGRect actRect = [playModel.actors boundingRectWithSize:CGSizeMake(SCREENWIDE, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        return (desRect.size.height + direRect.size.height + writRect.size.height + actRect.size.height + 90);
        
    }else if (indexPath.row == 1){
        CGRect rect = [playModel.introduction boundingRectWithSize:CGSizeMake(SCREENWIDE - 20, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        return rect.size.height;
    }else{
        return SCREENWIDE/2 + 45;
    }

}



// 返回自定义区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PlayModel *playModel = [self.dataArray firstObject];
    NSDictionary *dic = playModel.playurl;
    NSString *string = dic[self.clearStr];
    if (string.length == 0) {
        self.clearStr = @"360P";
        [self getNetWorkRequest];
        
    }
    
    NSURL *url = [NSURL URLWithString:string];
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.player.view.frame = CGRectMake(0, 20, SCREENWIDE, SCREENHEIGHT/3);
    // 屏幕宽高比例
    self.player.scalingMode = MPMovieScalingModeAspectFit;
    // 缩放比例
    self.player.scalingMode = MPMovieScalingModeAspectFit;

    self.player.shouldAutoplay = NO;
    [self.player prepareToPlay];
    [self.player play];
//    [self creatButton];
    // 观察全屏按钮属性变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFullScreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
    return self.player.view;
}
// 返回区头的高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 ) {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft |[UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
            return SCREENHEIGHT;
        }else{
            return SCREENHEIGHT/3;
        }
    }else{
        return 84;
    }
}

- (void)changeFullScreen:(id)sender{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    self.player.view.frame = CGRectMake(0, 0, SCREENHEIGHT, SCREENWIDE);
}
- (void)exitFullScreen:(id)sender{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    self.player.view.frame = CGRectMake(0, 0, SCREENWIDE, SCREENHEIGHT/3);
}


// 支持屏幕旋转
- (NSUInteger)supportedInterfaceOrientations{
    if (self) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}
// 屏幕旋转的时候调用
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    switch (toInterfaceOrientation) {
        case UIDeviceOrientationPortrait:
            self.navigationController.navigationBarHidden = NO;
            self.player.view.frame = CGRectMake(0, 0, SCREENHEIGHT, SCREENWIDE/3);
            break;
        case UIDeviceOrientationLandscapeLeft:
            self.navigationController.navigationBarHidden = YES;
            self.player.view.frame = CGRectMake(0, 0, SCREENHEIGHT, SCREENWIDE);
            break;
        case UIDeviceOrientationLandscapeRight:
            self.navigationController.navigationBarHidden = YES;
            self.player.view.frame = CGRectMake(0, 0, SCREENHEIGHT, SCREENWIDE);
            break;
        default:
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
