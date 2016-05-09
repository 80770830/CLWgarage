//
//  BuyNowController.m
//  CLWsdht
//
//  Created by OYJ on 16/4/21.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "BuyNowController.h"
#import "ImgModal.h"
#import "GoodInfoReturn.h"
#import "MJExtension.h"
#import "UserInfo.h"//用户模型信息
#import "AddressSelectController.h"


@interface BuyNowController ()
//地址信息
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *Mobile;

//商品信息
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel2;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;


@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;


//卖家留言
@property (weak, nonatomic) IBOutlet UITextField *leaveWordsTextField;
//合计
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalCount;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@end

@implementation BuyNowController
-(NSDictionary *)selectAddressDic
{
    if (!_selectAddressDic) {
        self.selectAddressDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys://修配厂信息
                               @"",@"Id",
                               @"",@"Mobile",
                               @"",@"Name",
                               @"",@"ProvincialId",
                               @"",@"ProvincialName",
                               @"",@"CityName",
                               @"",@"CityId",
                               @"",@"DistrictId",
                               @"",@"Address",
                               nil];
    }
    return _selectAddressDic;
}
-(void)viewWillAppear:(BOOL)animated
{
        if (self.newUsrAdsressState) {//选择新的用户地址
            //我的信息
            self.name.text=[self.selectAddressDic objectForKey:@"Name"];
            self.address.text=[NSString stringWithFormat:@"%@%@%@",[self.selectAddressDic objectForKey:@"ProvincialName"],[self.selectAddressDic objectForKey:@"CityName"],[self.selectAddressDic objectForKey:@"Address"]];
            self.Mobile.text=[self.selectAddressDic objectForKey:@"Mobile"];
        }
        else //默认登陆用户地址
        {
            //我的信息
            self.name.text=ApplicationDelegate.userInfo.Name;
            self.address.text=[NSString stringWithFormat:@"%@%@%@",ApplicationDelegate.userInfo.ProvincialName,ApplicationDelegate.userInfo.CityName,ApplicationDelegate.userInfo.Address];
            self.Mobile.text=ApplicationDelegate.userInfo.Mobile;
        }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *returnBut=[[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
    self.navigationItem.leftBarButtonItem=returnBut;
    [self updateUI];
    self.title=@"下单";
}
#pragma mark - UI&Data
-(void)updateUI
{
    NSLog(@"%@",self.storeName);
//商品信息
    //店铺名字
    self.storeName.text=self.goodInfo.StoreName;
    //商品图片
    ImgModal *modal=[self.goodInfo.Imgs objectAtIndex:0];
    [self.goodImage sd_setImageWithURL:[NSURL URLWithString:[modal valueForKey:@"Url"]] placeholderImage:[UIImage imageNamed:@"rc_ic_picture"]];
    //商品名字
    self.goodName.text=self.goodInfo.Name;
    //商品数量
    self.countLabel.text=@"×1";
    //商品新旧
    self.styleLabel1.text=self.goodInfo.PurityName;
    //商品性质
    self.styleLabel2.text=self.goodInfo.PartsSrcName;
    //商品价格
    self.goodPrice.text=[NSString stringWithFormat:@"￥%.2f",self.goodInfo.Price];
 //合计
    self.totalPrice.text=[NSString stringWithFormat:@"￥%.2f",self.goodInfo.Price];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Networking
/**
 *  @author oyj, 16-04-21
 *
 *  立即购买
 */
-(void)buyNowToNetwork
{
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/AddOrders"];
    
    NSString *Id=[MJYUtils mjy_uuid];
    NSString *OrdersId=[MJYUtils mjy_uuid];
    NSDictionary *garageOrdersJson =@{};
    NSDictionary *partsOrdersJson =@{
                                     @"Addr":self.address.text,
                                     @"CityId":[self.selectAddressDic objectForKey:@"CityId"],
                                     @"Consignee":self.name.text,
                                     @"GarageOrdersId":@"",
                                     @"Id":OrdersId,
                                     @"Mobile":ApplicationDelegate.userInfo.Mobile,
                                     @"Msg":self.leaveWordsTextField.text,
                                     @"Price":[NSString stringWithFormat:@"%.2f",[self.countTextField.text intValue]*self.goodInfo.Price],
                                     @"StoreId":self.goodInfo.UsrStoreId,
                                     @"UsrId":ApplicationDelegate.userInfo.user_Id,
                                     @"UsrType":@"1"
                                     };
    NSArray *partsOrdersJsonArray=@[partsOrdersJson];

    NSDictionary *partsLstJson =@{
                                  @"Cnt":self.countTextField.text,
                                  @"Id":Id,
                                  @"OrdersId":OrdersId,
                                  @"PartsId":self.goodInfo.Id,
                                  @"Price":[NSString stringWithFormat:@"%.2f",[self.countTextField.text intValue]*self.goodInfo.Price]
                                  };

    NSArray *partsLstJsonArray=@[partsLstJson];
    NSDictionary *paramDict = @{
                                @"garageOrdersJson":[JYJSON JSONStringWithDictionaryOrArray:garageOrdersJson],
                                @"partsOrdersJson":[JYJSON JSONStringWithDictionaryOrArray:partsOrdersJsonArray],
                                @"partsLstJson":[JYJSON JSONStringWithDictionaryOrArray:partsLstJsonArray],
                                };
    [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      //http请求状态
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                                      NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
                                          if (jsonDic[@"Success"]) {
                                                [self dismissViewControllerAnimated:YES completion:^{
                                                  [SVProgressHUD showSuccessWithStatus:@"订单提交成功！"];
                                              }];
                                              
                                          } else {
                                              //失败
                                              [SVProgressHUD showErrorWithStatus:@"订单提交失败！"];

                                          }
                                          
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];
}



#pragma mark - Action
-(IBAction)buyNowAction:(id)sender
{
    [self buyNowToNetwork];
}

- (IBAction)addressButton:(id)sender {
    UIStoryboard *addressSB= [UIStoryboard storyboardWithName:@"AddressSelect" bundle:nil];
    AddressSelectController *addressContr = [addressSB instantiateViewControllerWithIdentifier:@"AddressSelectController"];
    addressContr.buyNowContr=self;
    [self.navigationController pushViewController:addressContr animated:YES];
}

- (IBAction)addButtonAction:(id)sender {
    //更改数量
    int number=[self.countTextField.text intValue]+1;
    self.countLabel.text=[NSString stringWithFormat:@"×%d",number];
    self.countTextField.text=[NSString stringWithFormat:@"%d",number];
    //更改件数
    self.goodsTotalCount.text=[NSString stringWithFormat:@"共计%d件商品",number];
    //更改合计价格
    self.totalPrice.text=[NSString stringWithFormat:@"￥%.2f",number*self.goodInfo.Price];

}
- (IBAction)reduceButtonAction:(id)sender {
    //更改数量
    
    int number=[self.countTextField.text intValue]-1;
    if (number==0) {
        [SVProgressHUD showInfoWithStatus:@"购买数量不能低于1件"];
        return;
    }
    self.countLabel.text=[NSString stringWithFormat:@"×%d",number];
    self.countTextField.text=[NSString stringWithFormat:@"%d",number];
    //更改件数
    self.goodsTotalCount.text=[NSString stringWithFormat:@"共计%d件商品",number];
    //更改合计价格
    self.totalPrice.text=[NSString stringWithFormat:@"￥%.2f",number*self.goodInfo.Price];
    
}

//返回按钮
-(IBAction)returnAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}



@end
