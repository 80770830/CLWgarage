//
//  MapSelectPosViewController.m
//  CLWsdht
//
//  Created by tom on 16/4/22.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "MapSelectPosViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface MapSelectPosViewController () <BMKMapViewDelegate, BMKLocationServiceDelegate> {
    
    BMKMapView *_mapView;
    BMKLocationService *_locService;
}

@end

@implementation MapSelectPosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[BMKMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _mapView;
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
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


#pragma mark - 

- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate {
    
    NSLog(@"onLongClick lat %f,long %f", coordinate.latitude, coordinate.longitude);
    
    [self.delegate mapSelectPos:self latitude:coordinate.latitude longitude:coordinate.longitude];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    
    //NSLog(@"heading is %@",userLocation.heading);
    
    
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    //普通态
    //以下_mapView为BMKMapView对象
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView updateLocationData:userLocation];
    
    [_locService stopUserLocationService];
    
    [self.delegate mapSelectPos:self latitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    
}


@end
