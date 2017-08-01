//
//  POISearchModel.h
//  GaodeMap
//
//  Created by 周松 on 2017/7/26.
//  Copyright © 2017年 能环宝. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AMapPOI;
@class AMapImage;
@interface POISearchModel : NSObject
///名称
@property (nonatomic,copy) NSString *name;
///电话
@property (nonatomic,copy) NSString *tel;
///类型
@property (nonatomic,copy) NSString *type;
///地址
@property (nonatomic,copy) NSString *address;
///评分
@property (nonatomic,copy) NSString *rating;
///图片
@property (nonatomic, strong) NSArray<AMapImage *> *images;
///初始化
-(instancetype)initWithAMapPOI:(AMapPOI *)shopPOI;

@end
