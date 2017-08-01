//
//  LocationViewController.m
//  GaodeMap
//
//  Created by 周松 on 2017/7/26.
//  Copyright © 2017年 能环宝. All rights reserved.
//

#import "LocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface LocationViewController ()<MAMapViewDelegate,AMapSearchDelegate>
///地图
@property (nonatomic,strong) MAMapView *mapView;
///搜索引擎
@property (nonatomic,strong) AMapSearchAPI *searchAPI;

@end

@implementation LocationViewController {
    CLLocation * currentLocation;
    NSString *pointTitle;
    NSString *pointSubTitle;
    MAPointAnnotation *pointAnnotation;
}

- (MAMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
        //设置进入地图的缩放比例
        [_mapView setZoomLevel:17.5 animated:YES];
        //地图跟着位置移动
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:NO];
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        _mapView.showsUserLocation = YES;
        //如果不写这句话，就不会显示蓝色圆圈，也不会自动定位，这个貌似无法更改大小
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    
    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    //获取经纬度,这里获取的是地图中心点的坐标,不是当前用户所在地的中心点
    CLLocationCoordinate2D coordinate = self.mapView.centerCoordinate;
    
    //设置导航条的背景颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:69 / 255.0 green:207 / 255.0 blue:79 / 255.0 alpha:1]];
    //防止导航条按钮颜色被渲染
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.searchAPI = [[AMapSearchAPI alloc]init];
    self.searchAPI.delegate = self;
    
    CLLocationCoordinate2D coor ;
    coor.latitude = self.mapView.userLocation.coordinate.latitude;
    coor.longitude = self.mapView.userLocation.coordinate.longitude;
    NSLog(@"纬度 = %f  经度 = %f",coordinate.latitude,coordinate.longitude);

    pointAnnotation = [[MAPointAnnotation alloc] init];
//    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.911002,116.405877);
//    self.mapView.centerCoordinate = coor;
//    pointAnnotation.title = @"";
//    pointAnnotation.subtitle = self.mapView.userLocation.subtitle;
    
    //将大头针添加到地图中
    [_mapView addAnnotation:pointAnnotation];
    
    //默认选中气泡
    [self.mapView selectAnnotation:pointAnnotation animated:YES];
    
    
}
//添加覆盖的圆圈的代理方法
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleView = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleView.lineWidth = 5.f;
        circleView.strokeColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        circleView.fillColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:0.8];
        return circleView;
    }
    return nil;
}

//用户地址发生更新后执行
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    //将用户地址传入参数currentLocation
    currentLocation = [userLocation.location copy];
    //获得当前地理编码后，进行反编码，获得当前定位点的信息
    [self reGeoAction];
    
}
//地理反编码函数
-(void)reGeoAction {
    if (currentLocation) {
        //生成一个地理反编码的搜索
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        
        request.location = [AMapGeoPoint locationWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
        [self.searchAPI AMapReGoecodeSearch:request];
    }
}
// 反编码回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    //将搜索结果传给用户定位点，这样点击气泡就可以显示出详细信息
    NSString *title = response.regeocode.addressComponent.city;
    if (title.length ==0) {
        title = response.regeocode.addressComponent.province;
    }
    self.mapView.userLocation.title = title;
    self.mapView.userLocation.subtitle = response.regeocode.formattedAddress;
    [self.mapView selectedAnnotations];
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    pointAnnotation.title = title;
    pointAnnotation.subtitle = response.regeocode.formattedAddress;
    
    MACircle *circle = [MACircle circleWithCenterCoordinate:currentLocation.coordinate radius:1000];
    [self.mapView addOverlay:circle];
}


//添加大头针
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES; //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;  //设置标注动画显示，默认为NO
        annotationView.draggable = YES;     //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

//反编码时会进行一个搜索操作，搜索失败时会执行这个方法
- (void)searchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"request:%@,error:%@",request,error);
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
