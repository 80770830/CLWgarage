//
//  GrabSingleViewController.m
//  CLWsdht
//
//  Created by yang on 16/4/20.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "GrabSingleViewController.h"
#import "GrabSingleView.h"
#import "BaseHeader.h"
#import "UserInfo.h"

@interface GrabSingleViewController ()
{
    GrabSingleView *grabSingleView;
    NSTimer *timer;//定时器
    NSInteger time;//抢单时间
}

@end

@implementation GrabSingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self dataRequest];
}

//页面消失时移除定时器 回到原来的页面
- (void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderIsShow" object:nil];
}

//请求数据
- (void)dataRequest
{
    [SVProgressHUD showWithStatus:k_Status_Load];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"CompetitionOrder.asmx/GetGarageCompetitionOrder"];
    NSDictionary *paramDict = @{
                                @"CompetitionOrderId":self.msgText
                                };
    
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSLog(@"%@", jsonDic);
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                NSDictionary *dic = [JYJSON dictionaryOrArrayWithJSONSString:jsonDic[@"Data"]];
                NSLog(@"%@", dic);
                GrabSingleModel *model = [[GrabSingleModel alloc] initWithDictionary:dic];
                grabSingleView.model = model;
                
                [SVProgressHUD dismiss];
            } else {
                [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求异常
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
    }];
}

//取消按钮
- (void)backButtonClick:(UIButton *)sender
{
    [self.view removeFromSuperview];
}

//注册通知
- (void)regisiteNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(grabSingle:) name:@"GrabSingle" object:nil];
}

//抢单按钮
- (void)grabSingle:(NSNotification *)noti
{
    [SVProgressHUD showWithStatus:k_Status_Load];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"CompetitionOrder.asmx/AddGarageCompetitionOrder"];
    NSLog(@"%@", ApplicationDelegate.userInfo.user_Id);
    NSDictionary *paramDict = @{
                                @"CompetitionOrderId":self.msgText,
                                @"FuturePrice":[noti.userInfo objectForKey:@"price"],
                                @"UsrGarageId":ApplicationDelegate.userInfo.user_Id
                                };
    NSLog(@"%@", paramDict);
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSLog(@"%@", jsonDic);
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                [SVProgressHUD showInfoWithStatus:@"抢单成功"];
                    [self backButtonClick:nil];
            } else {
                [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求异常
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
    }];
}

//UI
- (void)loadUI
{
    self.title = @"实时抢单";
    self.view.backgroundColor = [UIColor cyanColor];
    self.navigationController.navigationBar.translucent = NO;
    grabSingleView = [[GrabSingleView alloc] initWithWidth:self.view.frame.size.width];
    grabSingleView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self.view addSubview:grabSingleView];
    //假的导航栏
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"取消抢单" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navigationView addSubview:backButton];
    backButton.frame = CGRectMake(10, 20, 75, 44);
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 75) / 2.0, 20, 75, 44)];
    title.text = @"实时订单";
    [navigationView addSubview:title];
    //设置定时器
    time = 30;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(singleTimeChange) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [self regisiteNotification];
}

//定时器方法
- (void)singleTimeChange
{
    if (time == 0) {
        [self.view removeFromSuperview];
    }
    time--;
    NSDictionary *dic = @{@"time":[NSString stringWithFormat:@"%ld", (long)time]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"singleTime" object:nil userInfo:dic];
}

//移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GrabSingle" object:nil];
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
