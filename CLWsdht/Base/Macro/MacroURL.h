//
//  MacroInterface.h
//  DengTa
//
//  Created by majinyu on 15/5/10.
//  Copyright (c) 2015年 com.majinyu. All rights reserved.
//

/***
 *     数据字典更新
 ***/

#define k_url_Dic_GetDicVer         @"Dic.asmx/GetDicVer"       // 获取字典最新版本号
#define k_url_Dic_GetCarBrand       @"Dic.asmx/GetCarBrand"     // 获取品牌
#define k_url_Dic_GetPartsUseFor    @"Dic.asmx/GetPartsUseFor"  // 配件分类
#define k_url_Dic_GetColour         @"Dic.asmx/GetColour"       // 获取颜色
#define k_url_Dic_GetPartsSrc       @"Dic.asmx/GetPartsSrc"     // 获取配件分类
#define k_url_Dic_GetPurity         @"Dic.asmx/GetPurity"       // 获取成色分类
#define k_url_Dic_GetProvincial     @"Dic.asmx/GetProvincial"   // 获取身份城市


/***
 *     用户授权
 ***/

#define k_url_auth_GetCaptcha       @"auth.asmx/GetCaptcha"         // 获取验证码
#define k_url_auth_GetBalance       @"auth.asmx/GetBalance"         // 我的钱包
#define k_url_auth_NewPwd           @"auth.asmx/NewPwd"             // 修改密码
#define k_url_auth_NewMobile        @"auth.asmx/NewMobile"          // 修改手机号

#define k_url_auth_GarageLogin       @"auth.asmx/GarageLogin"         // 验证码登录:快速注册
#define k_url_auth_GarageLoginByPwd  @"auth.asmx/GarageLoginByPwd"    // 密码登录
#define k_url_auth_GarageUpd         @"auth.asmx/GarageUpd"           // 帐户信息修改：细化注册信息
#define k_url_auth_GarageByMobile    @"auth.asmx/GarageByMobile"      // 帐户信息



#define k_url_verify_code_register @"auth.asmx/VerifyCaptcha"  //验证验证码(注册)

/**
*                                  获取验证码
 */
#define k_url_get_code             @"auth.asmx/GetCaptcha"     //获取验证码
#define k_url_get_userInfo         @"auth.asmx/UsrByMobile"  //获取用户信息


/**
*                                  登录注册
 */
#define k_url_login_pwd            @"auth.asmx/UsrLoginByPwd"//商家登录(密码)
#define k_url_login_code           @"auth.asmx/UsrLogin"     //商家登录(验证码)

/**
*                                  上传用户信息
 */
#define k_url_user_StoreUpd        @"auth.asmx/UsrUpd"       //上传用户信息(不含头像)
#define k_url_AddImg               @"Post/AddImg.aspx"         //上传图片(含头像)

/**
*                                  我的店铺
 */
#define k_url_GetCarBrand          @"Dic.asmx/GetCarBrand"    //获取品牌
#define k_url_GetPartsUseFor       @"Dic.asmx/GetPartsUseFor" //配件分类
#define k_url_GetColour            @"Dic.asmx/GetColour"      //获取颜色
#define k_url_GetPartsSrc          @"Dic.asmx/GetPartsSrc"    //获取配件分类
#define k_url_GetPurity            @"Dic.asmx/GetPurity"      //获取成色分类


#define k_url_AddParts             @"UsrStore.asmx/AddParts"   //添加配件
#define k_url_GetPartsDetail       @"UsrStore.asmx/GetPartsDetail"//获取配件详情
#define k_url_GetPartsList         @"UsrStore.asmx/GetPartsList"//获取商品列表





/**
 *      个人信息
 */

#define k_url_GetDemandList             @"Usr.asmx/GetDemandList"   //获取需求列表
#define k_url_GetDemandDetail           @"Usr.asmx/GetDemandDetail"//获取需求详情
#define k_url_GetAddressList         @"address.asmx/GarageGetList"//获取地址列表
#define k_url_AddAddress         @"address.asmx/AddGarageAddress"//添加地址
#define k_url_auth_NewPwd           @"auth.asmx/NewPwd"             // 修改密码
#define k_url_auth_NewMobile        @"auth.asmx/NewMobile"          // 修改手机号













