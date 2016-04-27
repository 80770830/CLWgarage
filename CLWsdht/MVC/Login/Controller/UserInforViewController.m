//
//  UserInforViewController.m
//  登陆注册模块
//
//  Created by tom on 16/1/7.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "UserInforViewController.h"
#import "UserInfo.h"//用户模型信息
#import "AddressJSONModel.h"//地址信息模型
#import "AddressGroupJSONModel.h"//
#import "CityListVC.h"//城市列表
#import "CustomAlertAction.h"
#import "MapSelectPosViewController.h"


@interface UserInforViewController ()<
UITextViewDelegate,
UIAlertViewDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
MapSelectPosDelegate
>{
    BOOL hasUserImage;//用户是否选择了头像(默认NO)
    BOOL hasUserCity;//用户是否选择了城市(默认NO)
    NSMutableArray *maAddressInfos;
    NSString *city_Id;//用户定位获取的城市的id信息
    
    NSMutableArray *brandDics;
    NSMutableArray *useForDics;
    NSString *brandStr;
    NSString *useForStr;
    
    NSString *latitudeStr;
    NSString *longitudeStr;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView       *contentView;


@property (weak, nonatomic) IBOutlet UIImageView *userImage;//头像
@property (weak, nonatomic) IBOutlet UITextField *passWord;//密码
@property (weak, nonatomic) IBOutlet UITextField *surePassWord;//确认密码
@property (weak, nonatomic) IBOutlet UITextField *userNumber;//身份证
@property (weak, nonatomic) IBOutlet UILabel     *lblCity;//城市
@property (weak, nonatomic) IBOutlet UIImageView *ivAddress;//地址标示ImageView
@property (weak, nonatomic) IBOutlet UIButton    *btnAddressSelete;//城市选择按钮
@property (weak, nonatomic) IBOutlet UITextField *storeName;//店铺名称
@property (weak, nonatomic) IBOutlet UILabel     *addressLabel;//placehold 地址
@property (weak, nonatomic) IBOutlet UITextView  *addressTextView;//详细地址
@property (weak, nonatomic) IBOutlet UILabel     *numberLabel;//数字label
@property (weak, nonatomic) IBOutlet UIButton    *btnSave;//保存按钮

@property (weak, nonatomic) IBOutlet UILabel *coordinateLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *userforLabel;



/**
 *  cons
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consContentViewHeight;//高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consContentViewWidth;//宽度

@end

@implementation UserInforViewController


- (IBAction)coordinateSelectButtonPressed:(id)sender {
    
    NSLog(@"coordinateSelectButtonPressed");
    
    MapSelectPosViewController *mapSelVC = [[MapSelectPosViewController alloc] initWithNibName:@"MapSelectPosViewController" bundle:nil];
    mapSelVC.delegate = self;
    [self.navigationController pushViewController:mapSelVC animated:YES];
}

- (IBAction)brandSelectButtonPressed:(id)sender {
    
    NSLog(@"brandSelectButtonPressed");
    
    
    NSString *dataFilePath = [DocumentBasePath stringByAppendingFormat:@"/%@.plist", @"CarBrandCarModel"];
    NSArray *tempBrands = [NSArray arrayWithContentsOfFile:dataFilePath];
    
    UIAlertController *sheetController= [UIAlertController alertControllerWithTitle:@"请选择维修品牌" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSDictionary *actionDic in tempBrands) {
        
        NSString *brandName = actionDic[@"Name"];
        NSString *brandId = actionDic[@"Id"];
        NSString *brandSIG = actionDic[@"SIG"];
        NSDictionary *brandDicTemp = @{@"Id":brandId, @"SIG":brandSIG};
        
        CustomAlertAction *alertAction = [CustomAlertAction actionWithTitle:brandName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            CustomAlertAction *alertActionTemp = (CustomAlertAction *)action;
            [brandDics removeAllObjects];
            [brandDics addObject:alertActionTemp.brandDic];
            
            NSLog(@"brandSelectButtonPressed, brandName - %@", alertActionTemp.brandName);
            _brandLabel.text = alertActionTemp.brandName;
            
        }];
        alertAction.brandName = brandName;
        alertAction.brandDic = [NSMutableDictionary dictionaryWithDictionary:brandDicTemp];
        [sheetController addAction:alertAction];
    }
    
    [self presentViewController:sheetController animated:YES completion:^{
        
    }];
    
}

- (IBAction)useforSelectButtonPressed:(id)sender {
    
    NSLog(@"useforSelectButtonPressed");
    
    NSString *dataFilePath = [DocumentBasePath stringByAppendingFormat:@"/%@.plist", @"PartsUseFor"];
    NSArray *tempUsefors = [NSArray arrayWithContentsOfFile:dataFilePath];
    
    
    
    UIAlertController *sheetController= [UIAlertController alertControllerWithTitle:@"请选择维修项目" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    
    for (NSDictionary *actionDic in tempUsefors) {
        
        NSString *brandName = actionDic[@"Name"];
        NSString *brandId = actionDic[@"Id"];
        NSString *brandSIG = actionDic[@"SIG"];
        NSDictionary *brandDicTemp = @{@"Id":brandId, @"SIG":brandSIG};
        
        CustomAlertAction *alertAction = [CustomAlertAction actionWithTitle:brandName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            CustomAlertAction *alertActionTemp = (CustomAlertAction *)action;
            [useForDics removeAllObjects];
            [useForDics addObject:alertActionTemp.brandDic];
            
            NSLog(@"brandSelectButtonPressed, brandName - %@", alertActionTemp.brandName);
            _userforLabel.text = alertActionTemp.brandName;
            
        }];
        alertAction.brandName = brandName;
        alertAction.brandDic = [NSMutableDictionary dictionaryWithDictionary:brandDicTemp];
        [sheetController addAction:alertAction];
    }
    
    
    
//    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        NSLog(@"useforSelectButtonPressed");
//    }];
//    
//    [sheetController addAction:alertAction];
    
    [self presentViewController:sheetController animated:YES completion:^{
        
    }];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _addressLabel.enabled = NO;
    _addressTextView.delegate = self;
    _btnSave.layer.cornerRadius  = 5;
    _consContentViewHeight.constant = CGRectGetMaxY(_btnSave.frame)+20;
    _consContentViewWidth.constant = SCREEN_WIDTH;
    
    
    hasUserImage = NO ;
    
    _lblCity.text = ApplicationDelegate.currentCity;
    city_Id = ApplicationDelegate.currentCityID;
    
    if (ApplicationDelegate.currentCityID) {
        hasUserCity = YES;
    } else {
        hasUserCity = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserAddressInfo:)
                                                 name:k_Notification_UpdateUserAddressInfo_Register
                                               object:nil];
    
    
    brandDics = [[NSMutableArray alloc] init];
    useForDics = [[NSMutableArray alloc] init];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:k_Notification_UpdateUserAddressInfo_Register
                                                  object:nil];
}


#pragma mark - MapSelectPosDelegate

- (void)mapSelectPos:(MapSelectPosViewController *)viewController latitude:(double)latitude longitude:(double)longitude {
    
    latitudeStr = [NSString stringWithFormat:@"%f", latitude];
    longitudeStr = [NSString stringWithFormat:@"%f", longitude];
    
    _coordinateLabel.text = [NSString stringWithFormat:@"(%@, %@)", latitudeStr, longitudeStr];
}



#pragma mark *** 通知中心方法 ***

/**
 *  更新用户地址选择
 *
 *  @param noti
 */
- (void)updateUserAddressInfo:(NSNotification *)noti {
    AddressJSONModel *addressModel = noti.object;
    city_Id = addressModel.city_id;
    _lblCity.text = addressModel.city_name;
    hasUserCity = YES;
}

#pragma mark *** 自定义方法 ***
//照相事件
- (void)openPhotoWithCamera {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//设置类型为相机
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;//设置代理
        picker.allowsEditing = YES;//设置照片可编辑
        picker.sourceType = sourceType;
        picker.videoQuality = UIImagePickerControllerQualityTypeLow;//分辨率(低)
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;//选择前置摄像头或后置摄像头
        [self presentViewController:picker animated:YES completion:^{}];
    } else {
        NSLog(@"该设备无相机");
    }
    
}

//打开相册
-(void)openPhotoWithAlbum {
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;//设置照片可编辑
    pickerImage.videoQuality =    UIImagePickerControllerQualityTypeLow;
    [self presentViewController:pickerImage animated:YES completion:^{}];
    
}

#pragma mark *** 头像按钮 ***

- (IBAction)userImageSeletedTap:(UITapGestureRecognizer *)sender {
    //创建对象
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"照相机",@"相册",
                                  nil];
    //展示对象
    [actionSheet showInView:self.view];
}

#pragma mark *** 选择城市 ***
- (IBAction)citySeletedAction:(UIButton *)sender {
    
    CityListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CityListVC"];
    vc.vcType = 1;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{}];
}


#pragma mark *** 保存按钮 ***
- (IBAction)saveBtn:(UIButton *)sender {
    
    if ([_passWord.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请输入登录密码"];
    } else if ([_surePassWord.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请输入确认密码"];
    } else if (![_surePassWord.text isEqualToString:_passWord.text]){
        [SVProgressHUD showErrorWithStatus:@"密码不一致"];
    } else if (![MJYUtils mjy_checkPersonID:_userNumber.text]){
        [SVProgressHUD showErrorWithStatus:@"身份证号格式有误"];
    } else if (!hasUserCity){
        [SVProgressHUD showErrorWithStatus:@"请选择所在城市"];
    } else if ([_storeName.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请输入店铺名称"];
    } else if ([_addressTextView.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请输入店铺详细地址"];
    } else if (brandDics.count == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择维修品牌"];
    } else if (useForDics.count == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择维修项目"];
    } else if (nil == latitudeStr || nil == longitudeStr || [@"" isEqualToString:latitudeStr] || [@"" isEqualToString:longitudeStr]) {
        [SVProgressHUD showErrorWithStatus:@"请选择店铺坐标"];
    } else {
        [self postUserInfoToNetwork];
    }
}

#pragma mark *** UIActionSheetDelegate ***
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //相机
        [self openPhotoWithCamera];
    } else if (buttonIndex == 1) {
        //相册
        [self openPhotoWithAlbum];
    } else {
        //取消
    }
}

#pragma mark *** textView Delegate ***
- (void) textViewDidChange:(UITextView *)textView {
    
    if ([_addressTextView.text length] == 0) {
        [_addressLabel setHidden:NO];
    } else {
        [_addressLabel setHidden:YES];
        if (_addressTextView.text.length > 50) {
            _addressTextView.text = [_addressTextView.text substringToIndex:50];
        }
        _numberLabel.text=[NSString stringWithFormat:@"%d/50",(int)(50 -_addressTextView.text.length)];
    }
    
}

#pragma mark *** ImagePickerViewController Delegate ***
//从相册选择图片后操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    //保存裁剪图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //上传用户头像信息
    [self postUserHeadImageToNetworkWithImage:image];
    
}

#pragma mark *** 上传用户的信息 ***

/**
 *  用户信息
 */
- (void) postUserInfoToNetwork {
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_auth_GarageUpd];
    
    //    NSDictionary *paramDict = @{
    //                                @"Id":ApplicationDelegate.userInfo.user_Id,
    //                                @"pwd":_passWord.text,
    //                                @"Name":_storeName.text,
    //                                @"CityId":city_Id,
    //                                @"IdNumber":_userNumber.text,
    //                                @"Address":_addressTextView.text
    //                                };
    //
    //    NSDictionary *jsonTabel = @{
    //                                @"storeJson":[JYJSON JSONStringWithDictionaryOrArray:paramDict]
    //                                };
    
    
    NSDictionary *garageDic = @{
                                @"Id":ApplicationDelegate.userInfo.user_Id,
                                @"pwd":_passWord.text,
                                @"Name":_storeName.text,
                                @"CityId":city_Id,
                                @"IdNumber":_userNumber.text,
                                @"Address":_addressTextView.text,
                                @"Lat": latitudeStr,//@"45.752078",
                                @"Lng": longitudeStr,//@"126.697115",
                                @"Mobile": ApplicationDelegate.userInfo.Mobile,//@"18686738863"
                                };
    
    NSArray *brands =   @[
                          @{@"Id": @"58709207-42ef-4c2b-b49f-fa9ef9f9e6c1",
                            @"SIG": @"E"},
                          @{@"Id": @"54e33666-0db8-4880-ba50-3f1d48773c70",
                            @"SIG": @"C"},
                          @{@"Id": @"6cc2e19e-3642-402f-9efa-a9a7c245acc6",
                            @"SIG": @"D"},
                          ];
    
    NSArray *useFors = @[
                         @{@"Id": @"df14887d-ff44-4736-9811-0707585b4d83",
                           @"SIG": @"k8"},
                         @{@"Id": @"abb909b8-a974-4c70-8344-1fc59620d3d2",
                           @"SIG": @"v8"},
                         @{@"Id": @"f4a1e1c2-8a88-4c2a-a8b9-3c795c5f176e",
                           @"SIG": @"u8"}
                         ];
    
    NSDictionary *jsonTabel = @{
                                @"garageJson":[JYJSON JSONStringWithDictionaryOrArray:garageDic],
                                @"brandsJson":[JYJSON JSONStringWithDictionaryOrArray:brandDics],
                                @"useForsJson":[JYJSON JSONStringWithDictionaryOrArray:useForDics]
                                };
    
    
    [ApplicationDelegate.httpManager POST:urlStr parameters:jsonTabel progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSLog(@"%@",jsonDic);
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                [SVProgressHUD showSuccessWithStatus:@"用户信息修改成功"];
                
                [self.navigationController popToViewController:ApplicationDelegate.loginViewController animated:YES];
                
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

/**
 *  上传用户头像信息
 */
- (void) postUserHeadImageToNetworkWithImage:(UIImage *)image {
    [SVProgressHUD showWithStatus:k_Status_UpLoad maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_AddImg];
    
    NSDictionary *paramDict = @{
                                @"Id":[MJYUtils mjy_uuid],//这个字段需要每次不同
                                @"dataId":ApplicationDelegate.userInfo.user_Id,//必须是用户的id
                                @"isSingle":@"true",
                                @"isFirst":@"true"
                                };
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        [formData appendPartWithFileData:imageData name:ApplicationDelegate.userInfo.user_Id fileName:ApplicationDelegate.userInfo.user_Id mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSLog(@"%@",jsonDic);
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                [SVProgressHUD showSuccessWithStatus:@"图像上传成功"];
                
                hasUserImage = YES;
                _userImage.image = image;
                
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

@end
