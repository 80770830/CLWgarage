//
//  ProductInfoViewController.m
//  PagingDemo
//
//  Created by Liu jinyong on 15/8/6.
//  Copyright (c) 2015年 Baidu 91. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "UIScrollView+JYPaging.h"
#import "ProductDetailViewController.h"
#import "GoodInfoReturn.h"
#import "MJExtension.h"
#import "ImgModal.h"
#import "StoreReturnData.h"
#import "CheckClassifyViewController.h"
#import "PartsListContr.h"
#import "BuyNowController.h"


#define DEVICE_3_5_INCH ([[UIScreen mainScreen] bounds].size.height == 480)
#define DEVICE_4_0_INCH ([[UIScreen mainScreen] bounds].size.height == 568)
#define DEVICE_4_7_INCH ([[UIScreen mainScreen] bounds].size.height == 667)
#define DEVICE_5_5_INCH ([[UIScreen mainScreen] bounds].size.height == 736)
@interface ProductInfoViewController (){
    StoreReturnData *storeInfoReturn;//配件商详情数据
    NSString *UsrStoreId;
    
    UIScrollView *detailScrollView;
}
//界面元素
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *pictureScrollView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *collection;

@property (weak, nonatomic) IBOutlet UIImageView *headPicture;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIImageView *shopStar;

@property (weak, nonatomic) IBOutlet UILabel *allGoodsNumber;
@property (weak, nonatomic) IBOutlet UILabel *allAttentionPeople;

@property (weak, nonatomic) IBOutlet UIButton *classButton;
@property (weak, nonatomic) IBOutlet UIButton *gotoShopButton;

@property (weak, nonatomic) IBOutlet UIButton *consultButton;


//数据
@property (strong,nonatomic)NSMutableArray *imageArray;//轮播图片
@property (strong,nonatomic)GoodInfoReturn *goodInfoReturn;//商品详情总体数据

@property(strong,nonatomic)BuyNowController *contr;//立即购买Contr
@end

@implementation ProductInfoViewController
-(BuyNowController *)contr
{
    if (!_contr) {
        self.contr=[[BuyNowController alloc]init];
    }
    return _contr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
//
    _scrollView.contentSize = CGSizeMake(0, 637);
    
        ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] init];
//    [self addChildViewController:detailVC];
    
    // just for force load view
    if (detailVC.view != nil) {
        _scrollView.secondScrollView = detailVC.scrollView;
    }
    self.title=@"商品详情";
    
    [self initData];

}

-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        self.imageArray=[NSMutableArray array];
    }
    return _imageArray;
}

#pragma mark - Data & UI
//数据
-(void)initData{
    [self getGoodsDetailInfoFromNetwork];
    [self getStoreDetailInfoFromNetwork];
}
//加图片
-(void)setScrollImage
{
    [self.imageArray removeAllObjects];
    for(NSDictionary *imgModal in self.goodInfoReturn.Data.Imgs)
    {
        NSLog(@"%@",[imgModal objectForKey:@"Url"]);
        [self.imageArray addObject:[imgModal objectForKey:@"Url"]];
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.pictureScrollView.frame delegate:self placeholderImage:[UIImage imageNamed:@"shangchuanzhaopian_mg_zuoqian"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    cycleScrollView.imageURLStringsGroup = self.imageArray;
    [self.pictureScrollView addSubview:cycleScrollView];
}
//更新商品基本数据
-(void)updateGoodsBasicInfoUI{
    [self setScrollImage];
    self.titleLabel.text=self.goodInfoReturn.Data.Name;
    self.price.text=[NSString stringWithFormat:@"￥%.2f",self.goodInfoReturn.Data.Price];
}

//更新配件商数据
-(void)updateStoreInfoUI{
    self.headPicture.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:storeInfoReturn.Data.Url]]];
    self.shopName.text=storeInfoReturn.Data.Name;
    //星级评价占位
    //全部宝贝数占位
    //关注人数占位
    
    
    
}

#pragma mark - Networking
/**
 *  @author oyj, 16-04-09
 *
 *  获取商品详情
 */

-(void)getGoodsDetailInfoFromNetwork
{
    
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"UsrStore.asmx/GetPartsDetail"];
    
    NSDictionary *paramDict = @{
                                @"id":self.goodID,
                                
                                };
    
    [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                          NSError* error;
                                          NSDictionary* jsonDic = [NSJSONSerialization
                                                                   JSONObjectWithData:responseObject
                                                                   options:kNilOptions
                                                                   error:&error];
                                          self.goodInfoReturn=[GoodInfoReturn mj_objectWithKeyValues:jsonDic];
                                          if (self.goodInfoReturn.Success) {
                                              UsrStoreId=self.goodInfoReturn.Data.UsrStoreId;
                                              [self updateGoodsBasicInfoUI];
                                              self.contr.goodInfo=self.goodInfoReturn.Data;
                                              [SVProgressHUD dismiss];
                                              
                                          } else {
                                              [SVProgressHUD showErrorWithStatus:k_Error_WebViewError];
                                              
                                          }
                                          
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];
    
}

/**
 *  @author oyj, 16-04-09
 *
 *  获取配件商信息
 */

-(void)getStoreDetailInfoFromNetwork
{
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"auth.asmx/StoreByMobile"];
    
    NSDictionary *paramDict = @{
                                @"mobile":self.storeMobile,
                                
                                };
    
    [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                          NSError* error;
                                          NSDictionary* jsonDic = [NSJSONSerialization
                                                                   JSONObjectWithData:responseObject
                                                                   options:kNilOptions
                                                                   error:&error];
                                          storeInfoReturn=[StoreReturnData mj_objectWithKeyValues:jsonDic];
                                          if (storeInfoReturn.Success) {
                                              [self updateStoreInfoUI];
                                              [SVProgressHUD dismiss];
                                              
                                          } else {
                                              [SVProgressHUD showErrorWithStatus:k_Error_WebViewError];
                                              
                                          }
                                          
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];
}
/**
 *  @author oyj, 16-04-15
 *
 *  加入购物车
 */


-(void)addCartToNetwork
{
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/AddCart"];
    
    NSDictionary *cartJson =@{
                              @"Cnt":@"1",
                              @"UsrId":ApplicationDelegate.userInfo.user_Id,
                              @"PartsId":self.goodID,
                              @"Id":[MJYUtils mjy_uuid],

                              
                              
                              };
    NSError *error;
    NSData *partsLstJsonArrayData = [NSJSONSerialization dataWithJSONObject:cartJson options:NSJSONWritingPrettyPrinted error:&error];
    NSString *partsLstJsonArrayDataJsonString = [[NSString alloc] initWithData:partsLstJsonArrayData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",partsLstJsonArrayDataJsonString);
    NSDictionary *paramDict = @{
                                @"cartJson":partsLstJsonArrayDataJsonString,
                                
                                };
        [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                          NSError* error;
                                          NSDictionary* jsonDic = [NSJSONSerialization
                                                                   JSONObjectWithData:responseObject
                                                                   options:kNilOptions
                                                                   error:&error];
                                          storeInfoReturn=[StoreReturnData mj_objectWithKeyValues:jsonDic];
                                          if (storeInfoReturn.Success) {
                                              
//                                              [SVProgressHUD dismiss];
                                              [SVProgressHUD showSuccessWithStatus:@"加入成功"];
                                              
                                          } else {
                                              [SVProgressHUD showErrorWithStatus:k_Error_WebViewError];
                                              
                                          }
                                          
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];
}
#pragma mark - 进店逛逛
- (IBAction)gotoShopAction:(id)sender {
    UIStoryboard *CheckClassify = [UIStoryboard storyboardWithName:@"CheckClassify" bundle:nil];
    PartsListContr *contr = (PartsListContr*)[CheckClassify instantiateViewControllerWithIdentifier:@"PartsListContr"];
    contr.UsrStoreId=UsrStoreId;
    contr.state=0;
    [self.navigationController pushViewController:contr animated:YES];
   
}
#pragma mark - 查看分类
- (IBAction)CheckClassifyAction:(id)sender {
    
    UIStoryboard *CheckClassify = [UIStoryboard storyboardWithName:@"CheckClassify" bundle:nil];
    CheckClassifyViewController *contr = (CheckClassifyViewController*)[CheckClassify instantiateViewControllerWithIdentifier:@"CheckClassifyViewController"];
    contr.StoreId=UsrStoreId;
    [self.navigationController pushViewController:contr animated:YES];
}
#pragma mark - 加入购物车
- (IBAction)addCartAction:(id)sender {
    [self addCartToNetwork];
}
#pragma mark - 立即购买
- (IBAction)buyNowAction:(id)sender {
//    [self.navigationController pushViewController:self.contr animated:YES];
    [self presentViewController:self.contr animated:YES completion:^{
        
    }];
}

@end
