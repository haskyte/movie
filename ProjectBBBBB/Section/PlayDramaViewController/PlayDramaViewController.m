//
//  PlayDramaViewController.m
//  ProjectBBBBB
//
//  Created by lanouhn on 15/7/25.
//  Copyright (c) 2015年 wujianqiang. All rights reserved.
//

#import "PlayDramaViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoModel.h"
#import "AFNetworking.h"
#import "DramaUrlModel.h"
#import "PlayModel.h"
#import "PlayInforTableViewCell.h"
#import "AboutTableViewCell.h"
#import "SetNumberTableViewCell.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "LikedList.h"

@interface PlayDramaViewController ()<UITableViewDataSource,UITableViewDelegate,AboutTableViewCellDelegate,SetNumberTableViewCellDelegate,UIActionSheetDelegate>
// 菊花
@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) UIButton *returnButton;

@property (nonatomic, strong) MPMoviePlayerController *player;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *videoArray;

@property (nonatomic, strong) NSString *setNumber;

// 视频清晰度
@property (nonatomic, strong) NSString *clearStr;
@property (nonatomic,strong) UIBarButtonItem *chooseBar;

@end

@implementation PlayDramaViewController

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [@[] mutableCopy];
    }
    return _dataArray;
}

- (NSMutableArray *)videoArray{
    if (_videoArray== nil) {
        self.videoArray = [@[] mutableCopy];
    }
    return _videoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearStr = @"360P";
    self.setNumber = @"1";
    // Do any additional setup after loading the view.
    self.tableView.showsVerticalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 请求视频数据
    [self getNetWorkRequest];
    [self creatRightButtonItem];
    [self.view addSubview:self.tableView];
    [self getTabelViewNetWorkRequest];
    
    
}

- (void)creatRightButtonItem{
    self.chooseBar = [[UIBarButtonItem alloc] initWithTitle:@"流畅" style:UIBarButtonItemStyleDone target:self action:@selector(choosePlayUrl:)];
    UIBarButtonItem *enjoyBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconSetting3"] style:UIBarButtonItemStyleDone target:self action:@selector(enjoyToFriends:)];
    
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    //    button.frame = CGRectMake(0, 0 , 20, 20);
    //    [button setBackgroundImage:[UIImage imageNamed:@"detail_icon_favorite"]forState:UIControlStateNormal];
    //    [button setBackgroundImage:[UIImage imageNamed:@"detail_icon_favorite_sel"]forState:UIControlStateSelected];
    //    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIImageView *likeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
   
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LikedList"];
    NSString *str = [NSString stringWithFormat:@"%@",self.videoModel.Id];
    request.predicate = [NSPredicate predicateWithFormat:@"videoID=%@",str];
    NSArray *array = [appdelegate.managedObjectContext executeFetchRequest:request error:nil];
    if (array.count == 0) {
        likeImage.image = [UIImage imageNamed:@"detail_icon_favorite"];
    }else{
        likeImage.image = [UIImage imageNamed:@"detail_icon_favorite_sel"];
    }
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:likeImage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSaveButton:)];
    likeImage.userInteractionEnabled = YES;
    [likeImage addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItems = @[enjoyBar,saveButton ,self.chooseBar];
}
// 轻拍切换图片
- (void)clickSaveButton:(UITapGestureRecognizer *)tap{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;

    UIImageView *likeImage = (UIImageView *)tap.view;
    if ([likeImage.image isEqual:[UIImage imageNamed:@"detail_icon_favorite"]]) {
        // 添加收藏
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_alert_updated"]];
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.labelText = @"已收藏";
        [self.HUD show:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.HUD hide:YES];
        });
        
        likeImage.image = [UIImage imageNamed:@"detail_icon_favorite_sel"];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LikedList"];
        NSString *str = [NSString stringWithFormat:@"%@",self.videoModel.Id];
        request.predicate = [NSPredicate predicateWithFormat:@"videoID=%@",str];
        NSArray *array = [appdelegate.managedObjectContext executeFetchRequest:request error:nil];
        if (array.count == 0) {
            NSEntityDescription *descript = [NSEntityDescription entityForName:@"LikedList" inManagedObjectContext:appdelegate.managedObjectContext];
            LikedList *likeList = [[LikedList alloc] initWithEntity:descript insertIntoManagedObjectContext:appdelegate.managedObjectContext];
            likeList.videoID = [NSString stringWithFormat:@"%@",self.videoModel.Id];
            likeList.title = self.videoModel.title;
            likeList.img = self.videoModel.img;
            likeList.score = [NSString stringWithFormat:@"%@",self.videoModel.score];
            likeList.descript = self.videoModel.introduction;
            likeList.time = [NSDate date];
        }
    }else{
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_alert_vip"]];
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.labelText = @"已取消";
        [self.HUD show:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.HUD hide:YES];
        });
        
        likeImage.image = [UIImage imageNamed:@"detail_icon_favorite"];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LikedList"];
        NSString *str = [NSString stringWithFormat:@"%@",self.videoModel.Id];
        request.predicate = [NSPredicate predicateWithFormat:@"videoID=%@",str];
        NSArray *array = [appdelegate.managedObjectContext executeFetchRequest:request error:nil];
        [appdelegate.managedObjectContext deleteObject:[array firstObject]];
    }
}




- (void)clickButton:(UIButton *)button{
    if (button.selected == YES) {
        button.selected = NO;
        
    }else if (button.selected == NO){
        button.selected = YES;
        
    }
}


// 点击第几集
- (void)postSetNumberWithNumber:(NSString *)setNumber{
    self.setNumber = setNumber;
    [self getNetWorkRequest];
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


// 请求视频数据
- (void)getNetWorkRequest{
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/drama_video?id=%@&episode=%@",self.videoModel.Id,self.setNumber]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        [self.HUD show:YES];
        
        [self getVideoDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
}
// 请求成功
- (void)getVideoDataSuccessWithObject:(id)object{
    [self.videoArray removeAllObjects];
    DramaUrlModel *dramaModel = [[DramaUrlModel alloc] init];
    [dramaModel setValuesForKeysWithDictionary:object];
    [self.videoArray addObject:dramaModel];
    [self.tableView reloadData];
    [self.HUD hide:YES];
    
}
// 请求tableView数据
- (void)getTabelViewNetWorkRequest{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api2.jxvdy.com/drama_info?id=%@&token=(null)",self.videoModel.Id]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self getTableViewDataSuccessWithObject:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
}
- (void)getTableViewDataSuccessWithObject:(id)object{
    [self.dataArray removeAllObjects];
    NSDictionary *dic = (NSDictionary *)object;

    PlayModel *playModel = [[PlayModel alloc] init];
    [playModel setValuesForKeysWithDictionary:dic];
    [self.dataArray addObject:playModel];
    [self.tableView reloadData];
}


- (IBAction)returnToRootViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark TableView delegate && dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayModel *playModel = [self.dataArray firstObject];
    self.navigationItem.title = playModel.title;
        if (indexPath.row == 0) {
            PlayInforTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inforCell"];
            if (cell == nil) {
                cell = [[PlayInforTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"inforcell"];
                cell.playModel = playModel;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
            
        }else if (indexPath.row == 1){
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"desCell"];
            cell.textLabel.text = [NSString stringWithFormat:@"剧情概述： %@",playModel.introduction];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.numberOfLines = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 2){
            AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell"];
            cell.delegate = self;
            if (cell == nil) {
                cell = [[AboutTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"aboutCell" withVideoID:self.videoModel.Id related:@"drama"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }else if (indexPath.row == 3){
            SetNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"numberCell"];
            if (cell == nil) {
                cell = [[SetNumberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"numberCell" withVideoID:self.videoModel.Id];
                cell.delegete = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }else{
            return nil;
        }
}

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
        return rect.size.height + 40;
    }else if (indexPath.row == 2){
        return SCREENHEIGHT/3 + 10;
    }else{
        return 110;
    }
}



// 回调cell 的id 再次请求数据
- (void)getVideoId:(NSString *)VideoID{
    self.videoModel.Id = VideoID;
    [self getTabelViewNetWorkRequest];
    [self getNetWorkRequest];
}

// 返回自定义区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    DramaUrlModel *dramaModel = [self.videoArray firstObject];
    NSDictionary *dic = dramaModel.playurl;
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
//  [self creatButton];
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
        return 0;
    }
}

- (void)changeFullScreen:(id)sender{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    self.player.view.frame = CGRectMake(0, 0, SCREENHEIGHT, SCREENWIDE);
    [self.returnButton removeFromSuperview];
}
- (void)exitFullScreen:(id)sender{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    self.player.view.frame = CGRectMake(0, 0, SCREENWIDE, SCREENHEIGHT/3);
    [self.view addSubview:self.returnButton];
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

//#pragma make collectionView dataSource & delegate
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//}


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
