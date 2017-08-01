//
//  POISearchResultViewController.h
//  GaodeMap
//
//  Created by 周松 on 2017/7/27.
//  Copyright © 2017年 能环宝. All rights reserved.
//

#import <UIKit/UIKit.h>
//获取所在坐标
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface POISearchResultViewController : UIViewController
///关键字
@property (nonatomic,copy) NSString *keyWord;

///经纬度对象
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@end
